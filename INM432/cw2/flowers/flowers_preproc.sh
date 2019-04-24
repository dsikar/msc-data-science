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

# Preprocess flowers dataset

#   ____
#  / __/__ _  __  _  _____ ________
# / _// _ \ |/ / | |/ / _ `/ __(_-<
#/___/_//_/___/  |___/\_,_/_/ /___/

# Now that we are set up, we can start processing some flowers images.
FLOWERS_PROJECT=$(gcloud config list project --format "value(core.project)")
# View at https://console.cloud.google.com/dataflow
FLOWERS_JOB_ID="flowers_${USER}_$(date +%Y%m%d_%H%M%S)"
# View at https://console.cloud.google.com/storage
FLOWERS_BUCKET="gs://${FLOWERS_PROJECT}-dsikar"
# Location where pre-processing files will be stored
FLOWERS_GCS_PATH="${FLOWERS_BUCKET}/flowers"
FLOWERS_DICT_FILE=gs://cloud-samples-data/ml-engine/flowers/dict.txt
# Model name
FLOWERS_MODEL_NAME=flowers
FLOWERS_VERSION_NAME=v1

echo
echo "Creating bucket"
gsutil mb ${FLOWERS_BUCKET}

echo
echo "Using job id: " $FLOWERS_JOB_ID
set -v -e

# Takes about 30 mins to preprocess everything.  We serialize the two
# preprocess.py synchronous calls just for shell scripting ease; you could use
# --runner DataflowRunner to run them asynchronously.  Typically,
# the total worker time is higher when running on Cloud instead of your local
# machine due to increased network traffic and the use of more cost efficient
# CPU's.  Check progress here: https://console.cloud.google.com/dataflow

#   ___
#  / _ \_______   ___  _______  _______ ___ ___
# / ___/ __/ -_) / _ \/ __/ _ \/ __/ -_|_-<(_-<
#/_/  /_/  \__/ / .__/_/  \___/\__/\__/___/___/
#              /_/

python trainer/preprocess.py \
  --input_dict "$FLOWERS_DICT_FILE" \
  --input_path "gs://cloud-samples-data/ml-engine/flowers/eval_set.csv" \
  --output_path "${FLOWERS_GCS_PATH}/preproc/eval" \
  --cloud

python trainer/preprocess.py \
  --input_dict "$FLOWERS_DICT_FILE" \
  --input_path "gs://cloud-samples-data/ml-engine/flowers/train_set.csv" \
  --output_path "${FLOWERS_GCS_PATH}/preproc/train" \
  --cloud

