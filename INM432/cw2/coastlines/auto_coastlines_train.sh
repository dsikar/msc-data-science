# ______         _
#/_  __/______ _(_)__
# / / / __/ _ `/ / _ \
#/_/ /_/  \_,_/_/_//_/

# Automated version - loop through dropout values
# Training on CloudML is quick after preprocessing (coastlines_preproc.sh).  If you ran
# the previous script asynchronously, make sure they have completed before calling
# this one.
# View at https://console.cloud.google.com/mlengine/jobs

# Automated version to loop through several dropout values

DROPOUT=$1
DROPOUT_DIR="${DROPOUT//./}"

# set environment variables
. coastlines_env_vars.sh

echo "Training with ${DROPOUT} dropout..."

gcloud ml-engine jobs submit training "$COASTLINE_JOB_ID" \
  --stream-logs \
  --module-name trainer.task \
  --package-path trainer \
  --staging-bucket "$COASTLINE_BUCKET" \
  --region us-central1 \
  --runtime-version=1.10 \
  -- \
  --output_path "${COASTLINE_GCS_PATH}/training/${DROPOUT_DIR}_dropout" \
  --eval_data_paths "${COASTLINE_GCS_PATH}/preproc/eval*" \
  --train_data_paths "${COASTLINE_GCS_PATH}/preproc/train*" \
  --label_count=18 \
  --dropout=${DROPOUT}

