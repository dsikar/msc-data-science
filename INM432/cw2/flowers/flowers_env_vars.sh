 # INM432 - CW2 - Daniel Sikar - PT1

 # Set flowers environment variables

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
