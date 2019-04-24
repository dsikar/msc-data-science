#!/bin/bash
# Copyright 2016 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This sample assumes you're already setup for using CloudML.  If this is your
# first time with the service, start here:
# https://cloud.google.com/ml/docs/how-tos/getting-set-up

# Now that we are set up, we can start processing some coastline images.
declare -r COASTLINE_PROJECT=$(gcloud config list project --format "value(core.project)")
declare -r COASTLINE_JOB_ID="coastlines_${USER}_$(date +%Y%m%d_%H%M%S)"
declare -r COASTLINE_BUCKET="gs://${COASTLINE_PROJECT}-coastline"
declare -r COASTLINE_GCS_PATH="${COASTLINE_BUCKET}/${USER}/${COASTLINE_JOB_ID}"
declare -r COASTLINE_DICT_FILE=gs://tamucc_coastline/dict.txt
declare -r COASTLINE_MODEL_NAME=coastlines
declare -r COASTLINE_VERSION_NAME=v1

echo
echo "Creating bucket"
gsutil mb ${COASTLINE_BUCKET}

echo
echo "Using job id: " $COASTLINE_JOB_ID
set -v -e

echo
echo "Creating evaluation and training sets"

# make local copy
gsutil cp gs://tamucc_coastline/labeled_images.csv .
# get image list
gsutil ls gs://tamucc_coastline/esi_images/ > image_list.txt
# fix extensions
python fix_extension_case.py
# rename
mv labeled_images_fixed.csv labeled_images.csv
# split into evaluation and training sets
python eval_train.py
# copy evaluation and training sets to bucket
gsutil cp *_set.csv ${COASTLINE_BUCKET}
# cleanup
rm *.csv

# Takes about 30 mins to preprocess everything.  We serialize the two
# preprocess.py synchronous calls just for shell scripting ease; you could use
# --runner DataflowRunner to run them asynchronously.  Typically,
# the total worker time is higher when running on Cloud instead of your local
# machine due to increased network traffic and the use of more cost efficient
# CPU's.  Check progress here: https://console.cloud.google.com/dataflow
python trainer/preprocess.py \
  --input_dict "$COASTLINE_DICT_FILE" \
  --input_path "${COASTLINE_BUCKET}/eval_set.csv" \
  --output_path "${COASTLINE_GCS_PATH}/preproc/eval" \
  --cloud
python trainer/preprocess.py \
  --input_dict "$COASTLINE_DICT_FILE" \
  --input_path "${COASTLINE_BUCKET}/train_set.csv" \
  --output_path "${COASTLINE_GCS_PATH}/preproc/train" \
  --cloud

# Training on CloudML is quick after preprocessing.  If you ran the above
# commands asynchronously, make sure they have completed before calling this one.
gcloud ml-engine jobs submit training "$COASTLINE_JOB_ID" \
  --stream-logs \
  --module-name trainer.task \
  --package-path trainer \
  --staging-bucket "$COASTLINE_BUCKET" \
  --region us-central1 \
  --runtime-version=1.10 \
  -- \
  --output_path "${COASTLINE_GCS_PATH}/training" \
  --eval_data_paths "${COASTLINE_GCS_PATH}/preproc/eval*" \
  --train_data_paths "${COASTLINE_GCS_PATH}/preproc/train*" \
  --label_count=18 \
  --dropout=0.5 \
  --batch_size=100

# Remove the model and its version
# Make sure no error is reported if model does not exist
gcloud ml-engine versions delete $COASTLINE_VERSION_NAME --model=$COASTLINE_MODEL_NAME -q --verbosity none
gcloud ml-engine models delete $COASTLINE_MODEL_NAME -q --verbosity none

# Tell CloudML about a new type of model coming.  Think of a "model" here as
# a namespace for deployed Tensorflow graphs.
gcloud ml-engine models create "$COASTLINE_MODEL_NAME" \
  --regions us-central1

# Each unique Tensorflow graph--with all the information it needs to execute--
# corresponds to a "version".  Creating a version actually deploys our
# Tensorflow graph to a Cloud instance, and gets is ready to serve (predict).
gcloud ml-engine versions create "$COASTLINE_VERSION_NAME" \
  --model "$COASTLINE_MODEL_NAME" \
  --origin "${COASTLINE_GCS_PATH}/training/model" \
  --runtime-version=1.10

# Models do not need a default version, but its a great way move your production
# service from one version to another with a single gcloud command.
gcloud ml-engine versions set-default "$COASTLINE_VERSION_NAME" --model "$COASTLINE_MODEL_NAME"

# Finally, download a daisy and so we can test online prediction.
#gsutil cp \
#  gs://tamucc_coastline/esi_images/IMG_0001_SecBC_Spr12.jpg \
#  IMG_0001_SecBC_Spr12.jpg
# This file is over the limit ~ 1.5MB so we have pre-processed one
# Since the image is passed via JSON, we have to encode the JPEG string first.
python -c 'import base64, sys, json; img = base64.b64encode(open(sys.argv[1], "rb").read()); print json.dumps({"key":"0", "image_bytes": {"b64": img}})' IMG_0001_SecBC_Spr12.jpg &> request.json

# Here we are showing off CloudML online prediction which is still in beta.
# If the first call returns an error please give it another try; likely the
# first worker is still spinning up.  After deploying our model we give the
# service a moment to catch up--only needed when you deploy a new version.
# We wait for 1 minute here, but often see the service start up sooner.
sleep 1m
gcloud ml-engine predict --model ${COASTLINE_MODEL_NAME} --json-instances request.json
# TODOS
# 1. Resize downloaded image to comply with size (json requrest)
# 2. Create background job
# 3. Run image classification and match to label
