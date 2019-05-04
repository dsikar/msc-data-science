# Tell CloudML about a new type of model coming.  Think of a "model" here as
# a namespace for deployed Tensorflow graphs.
gcloud ml-engine models create "$MODEL_NAME" \
  --regions us-central1

# Each unique Tensorflow graph--with all the information it needs to execute--
# corresponds to a "version".  Creating a version actually deploys our
# Tensorflow graph to a Cloud instance, and gets is ready to serve (predict).
gcloud ml-engine versions create "$VERSION_NAME" \
  --model "$MODEL_NAME" \
  --origin "${GCS_PATH}/training/model" \
  --runtime-version=1.10

# Models do not need a default version, but its a great way move your production
# service from one version to another with a single gcloud command.
gcloud ml-engine versions set-default "$VERSION_NAME" --model "$MODEL_NAME"

# Finally, download a daisy and so we can test online prediction.
gsutil cp \
  gs://tamucc_coastline/esi_images/IMG_0001_SecBC_Spr12.jpg \
  IMG_0001_SecBC_Spr12.jpg
# Since the image is passed via JSON, we have to encode the JPEG string first.
python -c 'import base64, sys, json; img = base64.b64encode(open(sys.argv[1], "rb").read()); print json.dumps({"key":"0", "image_bytes": {"b64": img}})' IMG_0001_SecBC_Spr12.jpg &> request.json

# Here we are showing off CloudML online prediction which is still in beta.
# If the first call returns an error please give it another try; likely the
# first worker is still spinning up.  After deploying our model we give the
# service a moment to catch up--only needed when you deploy a new version.
# We wait for 1 minute here, but often see the service start up sooner.
sleep 1m
gcloud ml-engine predict --model ${MODEL_NAME} --json-instances request.json
