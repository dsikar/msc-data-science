function rbm_lab()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exprimental code for Restricted Boltzmann Machines    %
% The code is developed for Neural Computing tutorial   %
% MSc on Data Science, CITY UNIVERSITY LONDON           %
% Authors: Son Tran, Artur Garcez                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Adding path the deep net library
addpath(genpath('.'));
%% Define the parameters
conf.hidNum    = 100;  % Number of hidden units
conf.eNum      = 50;   % Number of epoch
conf.bNum      = 0;    % Batch number, 0 means it will be decided by the number of training samples
conf.sNum      = 100;  % Number of samples in one batch
conf.gNum      = 1;    % Number of Gibbs sampling
conf.params(1) = 0.5;  % Learning rate (starting)
conf.params(2) = conf.params(1); % This is unused
conf.params(3) = 0.01; % Momentum
conf.params(4) = 0.05;%0.00002; % Weight decay

conf.sparsity = 'EMIN';
conf.lambda    = 5;    % Sparsity penalty
conf.p         = 0 .0001;% Sparsity constraint

conf.E_STOP_LR_REDUCE = 50;
conf.E_STOP = 5;
conf.gen  = 0;

conf.plot = 1; % Show plots

%% Training RBMs
conf.trn_dat_file = 'mnist_train_dat_5k.mat';
conf.trn_lab_file = 'mnist_train_lab_5k.mat';
conf.vld_dat_file = 'mnist_vld_dat_10k.mat';
conf.vld_lab_file = 'mnist_vld_lab_10k.mat';

model = class_rbm_train(conf);
%% Rank features with L1-norm
   % YOUR CODE
%% Visualization of features
figure;
visualize_1l_filters(model.W,100,28,28,'minmax');
%% Application 1: Classification
fprintf('-----------------------------------------------------------\n');
fprintf('Starting Application 1: Classification using RBMs. Press any key to continue...\n');
pause;
tst_dat_file = 'mnist_test_dat_10k.mat';
tst_lab_file = 'mnist_test_lab_10k.mat';
tst_dat = get_data_from_file(tst_dat_file);
tst_lab = get_data_from_file(tst_lab_file);
output = rbm_classify(model,tst_dat,2);
acc = sum((output==tst_lab+1))/size(tst_dat,1);
fprintf('[App 1] Test accuracy(RBM classification): %.5f\n',acc);
%%% Application 2: Feature extraction
%% For this, the version of LibSVM for matlab needs to be downloaded and
%% installed on your machine.
%% Instructions and support may be found here:
%% http://www.csie.ntu.edu.tw/~cjlin/libsvm/#matlab
%fprintf('-----------------------------------------------------------\n');
%fprintf('Starting Application 2: Classification using SVM with RBMs features. Press any key to continue...\n');
%pause;
%addpath(genpath('libsvm-3.21/matlab'));
%tst_dat_file = 'mnist_test_dat_10k.mat';
%tst_lab_file = 'mnist_test_lab_10k.mat';
%
%trn_features = logistic(bsxfun(@plus,get_data_from_file(conf.trn_dat_file)*model.W,model.hidB));
%trn_labels   = get_data_from_file(conf.trn_lab_file);
%tst_features = logistic(bsxfun(@plus,get_data_from_file(tst_dat_file)*model.W,model.hidB));
%tst_labels   = get_data_from_file(tst_lab_file);
%svmmod = svmtrain(trn_labels, trn_features,['-q -c 10 -g 0.01']); % Change value of c & g to get better result
%[~, accuracy,~] = svmpredict(tst_labels, tst_features, svmmod);
%tst_acc = accuracy(1);         
%fprintf('[App 2] Test accuracy (RBM features): %.5f\n',tst_acc);
%%% Application 3: Transfer Learning
%fprintf('-----------------------------------------------------------\n');
%fprintf('Starting Application 3: Transfer handwritten digit representation to recognize Arabic writers. Press any key to continue...\n');
%pause;
%target_trn_dat_file = 'madbase_trnwtr_dat_file_28x28_300.mat';
%target_trn_lab_file = 'madbase_trnwtr_lab_file_300.mat';
%target_tst_dat_file = 'madbase_tstwtr_dat_file_28x28_350.mat';
%target_tst_lab_file = 'madbase_tstwtr_lab_file_350.mat';
%
%trn_features = logistic(bsxfun(@plus,get_data_from_file(target_trn_dat_file)*model.W,model.hidB));
%trn_labels   = get_data_from_file(target_trn_lab_file);
%tst_features = logistic(bsxfun(@plus,get_data_from_file(target_tst_dat_file)*model.W,model.hidB));
%tst_labels   = get_data_from_file(target_tst_lab_file);
%svmmod = svmtrain(trn_labels, trn_features,['-q -c 10 -g 0.01']); % Change value of c & g to get better result
%[~, accuracy,~] = svmpredict(tst_labels, tst_features, svmmod);
%tst_acc = accuracy(1);         
%fprintf('[App 3] Test accuracy (RBM Transfer): %.5f\n',tst_acc);
%% Application 4: Denoising
% In this application, number of Gibbs sampling in the training is very important
fprintf('-----------------------------------------------------------\n');	
fprintf('Starting Application 4: Denoising impaired images. Press any key to continue...');
pause;
tst_dat_file = 'mnist_test_dat_10k.mat';
dat = get_data_from_file(tst_dat_file);
dev = 0.2;% Standard deviation of Gaussian noise
impaired = dat+dev*randn(size(dat));
hidS = logistic(bsxfun(@plus,impaired*model.W,model.hidB));
hidS = hidS>rand(size(hidS));
reconstructed  = logistic(bsxfun(@plus,hidS*model.W',model.visB));
MSE = sum(sum((dat - reconstructed).^2))/numel(dat);
fprintf('[App 4] Reconstruction Error %.5f',MSE);
figure();
subplot(1,3,1);show_images(dat,100,28,28);
subplot(1,3,2);show_images(impaired,100,28,28);
subplot(1,3,3);show_images(reconstructed,100,28,28);
end
