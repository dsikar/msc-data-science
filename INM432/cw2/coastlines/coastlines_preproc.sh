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

# INM432 - CW2 - Daniel Sikar - PT1

# Preprocess coastline dataset

#   ____
#  / __/__ _  __  _  _____ ________
# / _// _ \ |/ / | |/ / _ `/ __(_-<
#/___/_//_/___/  |___/\_,_/_/ /___/

# Now that we are set up, we can start processing some coastline images.
declare -r COASTLINE_PROJECT=$(gcloud config list project --format "value(core.project)")
declare -r COASTLINE_JOB_ID="coastlines_${USER}_$(date +%Y%m%d_%H%M%S)"
declare -r COASTLINE_BUCKET="gs://${COASTLINE_PROJECT}-dsikar-coastline"
declare -r COASTLINE_GCS_PATH="${COASTLINE_BUCKET}/${USER}/${COASTLINE_JOB_ID}"
declare -r COASTLINE_DICT_FILE=gs://tamucc_coastline/dict.txt
declare -r COASTLINE_MODEL_NAME=coastlines-dsikar
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

