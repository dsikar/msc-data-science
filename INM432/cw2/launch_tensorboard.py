from google.datalab.ml import *

# flowers 0.5 dropout
model_dir = 'gs://inm432-cw2-dsikar/daniel_sikar/flowers_daniel_sikar_20190417_143242/training/model'
print 'Model directory...'
print model_dir
tb_id = TensorBoard.start(model_dir)
print 'TensorBoard ID...'
print tb_id

# open tensorboard for model
#bucket = 'gs://' + datalab_project_id() + '-txf'
#bucket + '/model'

# stop
# TensorBoard.stop(tb_id)
