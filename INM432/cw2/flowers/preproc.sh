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

# Now that we are set up, we can start processing some flowers images.
declare -r PROJECT=$(gcloud config list project --format "value(core.project)")
# View at https://console.cloud.google.com/dataflow
declare -r JOB_ID="flowers_${USER}_$(date +%Y%m%d_%H%M%S)"
declare -r LOG_FILE="${JOB_ID}.log"
# View at https://console.cloud.google.com/storage
declare -r BUCKET="gs://${PROJECT}-ml-7"
# Location where pre-processing files will be stored 
declare -r GCS_PATH="${BUCKET}/${USER}/${JOB_ID}"
declare -r DICT_FILE=gs://cloud-samples-data/ml-engine/flowers/dict.txt
# Model name
declare -r MODEL_NAME=flowers
declare -r VERSION_NAME=v3

echo
echo "Creating bucket"
gsutil mb ${BUCKET}

echo
echo "Using job id: " $JOB_ID
set -v -e

# Takes about 30 mins to preprocess everything.  We serialize the two
# preprocess.py synchronous calls just for shell scripting ease; you could use
# --runner DataflowRunner to run them asynchronously.  Typically,
# the total worker time is higher when running on Cloud instead of your local
# machine due to increased network traffic and the use of more cost efficient
# CPU's.  Check progress here: https://console.cloud.google.com/dataflow
python trainer/preprocess.py \
  --input_dict "$DICT_FILE" \
  --input_path "gs://cloud-samples-data/ml-engine/flowers/eval_set.csv" \
  --output_path "${GCS_PATH}/preproc/eval" \
  --cloud >> "${LOG_FILE}"

python trainer/preprocess.py \
  --input_dict "$DICT_FILE" \
  --input_path "gs://cloud-samples-data/ml-engine/flowers/train_set.csv" \
  --output_path "${GCS_PATH}/preproc/train" \
  --cloud >> "${LOG_FILE}"
 

