# Click Web Preview button on top right after running
DROPOUT_DIR=$1
tensorboard --logdir=gs://inm432-cw2-dsikar/coastlines/training/${DROPOUT_DIR}_dropout/train_set --port=8080


