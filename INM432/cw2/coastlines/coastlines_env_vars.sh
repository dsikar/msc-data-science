
# INM432 - CW2 - Daniel Sikar - PT1

# Preprocess coastline dataset

#   ____
#  / __/__ _  __  _  _____ ________
# / _// _ \ |/ / | |/ / _ `/ __(_-<
#/___/_//_/___/  |___/\_,_/_/ /___/

# Now that we are set up, we can start processing some coastline images.
COASTLINE_PROJECT=$(gcloud config list project --format "value(core.project)")
COASTLINE_JOB_ID="coastlines_${USER}_$(date +%Y%m%d_%H%M%S)"
COASTLINE_BUCKET="gs://${COASTLINE_PROJECT}-dsikar"
COASTLINE_GCS_PATH="${COASTLINE_BUCKET}/coastlines"
COASTLINE_DICT_FILE=gs://tamucc_coastline/dict.txt
COASTLINE_MODEL_NAME=coastlines
COASTLINE_VERSION_NAME=v1

 echo
 echo "Using job id: " $COASTLINE_JOB_ID
