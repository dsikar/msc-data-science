
# ______         _
#/_  __/______ _(_)__
# / / / __/ _ `/ / _ \
#/_/ /_/  \_,_/_/_//_/

# Training on CloudML is quick after preprocessing (flowers_preproc.sh).  If you ran
# the previous script asynchronously, make sure they have completed before calling
# this one.
# View at https://console.cloud.google.com/mlengine/jobs
DROPOUT="0.9"
echo "Training with ${DROPOUT} dropout..."
# prefix for dropout gcloud "directory" object
DROPOUT_DIR="${DROPOUT//./}"
gcloud ml-engine jobs submit training "$FLOWERS_JOB_ID" \
  --stream-logs \
  --module-name trainer.task \
  --package-path trainer \
  --staging-bucket "$FLOWERS_BUCKET" \
  --region us-central1 \
  --runtime-version=1.10 \
  -- \
  --output_path "${FLOWERS_GCS_PATH}/training/${DROPOUT_DIR}_dropout" \
  --eval_data_paths "${FLOWERS_GCS_PATH}/preproc/eval*" \
  --train_data_paths "${FLOWERS_GCS_PATH}/preproc/train*" \
  --dropout=${DROPOUT}

