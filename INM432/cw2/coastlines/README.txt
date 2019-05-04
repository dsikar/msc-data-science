INM-432-CW2 - Daniel Sikar - daniel.sikar@city.ac.uk

The following files were used to process coastlines data:

auto_coastlines_train.sh - Automate dropouts
auto_train.sh - Dropout scripts
coastlines_env_vars.sh - Set environment variables
coastlines_preproc.sh - Preprocessing section
coastlines.sh - Original modifying script with end to end run
coastlines_train.sh - Training section
eval_train.py - Split data into evaluation and training sets
fix_extension_case.py - Fix file extension
images_to_json.py - original json encoder
IMG_0001_SecBC_Spr12.jpg - Test image file reduced to 1MB - this will keep encoded request within limit.
__init__.py - original init file
job.sh - original job file
make_bucket_public.sh - change bucket permissions to allow examiners to view outputs
pipeline.py - original pipeline file
README.txt - This file
request.json - Original request
requirements.txt - Original requirements
setup.py - Original setup
start_tensorboard.sh - Start tensorboard - required 01 to 09 dropout
trainer - original trianer directory

To run entire job:
$ . coastlines.sh

To run Tensorboard
# With 0.5 dropout
$ . start_tensorboard.sh 05
