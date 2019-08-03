function deepnet_lab()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exprimental code for Deep Learning                    %
% The code is developed for Neural Computing tutorial   %
% MSc on Data Science, CITY UNIVERSITY LONDON           %
% Authors: Son Tran, Artur Garcez                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clc;
clear;
addpath(genpath('.'));

% Define the network - one input, three hiddenlayers and one output layer 
conf.hidNum = [20 40 30];
% Load the data files
trn_dat_file = 'mnist_train_dat_5k.mat';
trn_lab_file = 'mnist_train_lab_5k.mat';
vld_dat_file = 'mnist_vld_dat_10k.mat';
vld_lab_file = 'mnist_vld_lab_10k.mat';
tst_dat_file = 'mnist_test_dat_10k.mat';
tst_lab_file = 'mnist_test_lab_10k.mat';
    

%% Pre-training
mkdir('../MOD');
depth = size(conf.hidNum,2);
pre_train = {'rbm','ae','rbm'}; % The pre-training of each layer: rbm or ae; rbm with softmax must be at the top
learning_rates = [0.5,0.5,0.3]; % The learning rates for each of the above
momentums      = [0.01,0.005,0.001]; % The momentum for the above
weight_decays = [0.00002,0.001,0.002]; % The weight decay parameters

ll.trn_dat_file = trn_dat_file;
ll.trn_lab_file = trn_lab_file;
ll.vld_dat_file = vld_dat_file;
ll.vld_lab_file = vld_lab_file;
for i=1:depth
    fprintf('Pre-train Deep Layer %d\n',i);
    ll.hidNum = conf.hidNum(i);   
    ll.eNum      = 10;   % Number of epochs
    ll.bNum      = 0;    % Number of batches; 0 means use the number of training samples
    ll.sNum      = 100;  % Number of samples in one batch
    ll.gNum      = 1;    % Number of Gibbs sampling; e.g. CD1
    ll.params(1) = learning_rates(i);  % Learning rate (starting)
    ll.params(2) = ll.params(1); % This is unused
    ll.params(3) = momentums(i); % Momentum
    ll.params(4) = weight_decays(i); % Weight decay
    
    ll.lambda = 0;
    ll.plot = 1; % Show plots

    %% Training RBMs  
    if i<depth
        if ~exist(strcat('../MOD/layer',num2str(i),'.mat'),'file') % if the layer has not been trained
            if strcmp(pre_train{i},'rbm')
                ll.N = 10; % Ignore it
                model = gen_rbm_train(ll);
            elseif strcmp(pre_train{i},'ae')
                model = train_ae(ll)
            end
            save(strcat('../MOD/layer',num2str(i),'.mat'),'model');
        else
            fprintf('... this has been trained already\n');
            load(strcat('../MOD/layer',num2str(i),'.mat'));
        end
        
        % save features file for next layer            
        trn_fts = logistic(bsxfun(@plus,get_data_from_file(ll.trn_dat_file)*model.W,model.hidB));    
        save(strcat('../MOD/layer',num2str(i),'_trn_fts.mat'),'trn_fts');
        vld_fts = logistic(bsxfun(@plus,get_data_from_file(ll.vld_dat_file)*model.W,model.hidB));    
        save(strcat('../MOD/layer',num2str(i),'_vld_fts.mat'),'vld_fts');
        
        Ws{i} = model.W;
    else % Top layer
        ll.gen = 1;
        ll.E_STOP_LR_REDUCE = 50;
        ll.E_STOP = 5;

        if ~exist(strcat('../MOD/layer',num2str(i),'.mat'),'file')
            ll = rmfield(ll,'N'); % Ignore it
            model = class_rbm_train(ll);
            save(strcat('../MOD/layer',num2str(i),'.mat'),'model');
        else
            fprintf('... this has been trained already\n');
            load(strcat('../MOD/layer',num2str(i),'.mat'));
        end
        Ws{i} = model.W;
        Ws{i+1} = model.U';
    end
    ll.trn_dat_file = strcat('../MOD/layer',num2str(i),'_trn_fts.mat');    
    ll.vld_dat_file = strcat('../MOD/layer',num2str(i),'_vld_fts.mat');
end

clear model;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fine-tuning
fprintf('===============================\nFine Tuning\n=========================\n');
conf.activationFnc = {'logsig','logsig','logsig','logsig'}; % Fixed, this should not be changed
conf.eNum   = 100; % Change this to 1000 and inspect error rate improvement
conf.bNum   = 0;   % Automatically set: number of batches 
conf.sNum   = 100; % Number of samples in one batch
conf.params = [0.5 0.1 0.1 0.0001];

conf.E_STOP = 10;

trn_dat = get_data_from_file(trn_dat_file);
trn_lab = get_data_from_file(trn_lab_file);
vld_dat = get_data_from_file(vld_dat_file);
vld_lab = get_data_from_file(vld_lab_file);
tst_dat = get_data_from_file(tst_dat_file);
tst_lab = get_data_from_file(tst_lab_file);

figure();show_images(trn_dat,100,28,28);
pause(0.1);

% Learing rate decay & Early stopping for fine tuning
conf.E_STOP_LR_REDUCE = 50;
conf.E_STOP = 5;
model = train_nn(conf,Ws,[],trn_dat,trn_lab,vld_dat,vld_lab);


if exist('tst_dat','var')
   cout = run_nn(conf.activationFnc,model,tst_dat);
   tst_acc = sum((cout-1)==tst_lab)/size(tst_lab,1);
   fprintf('Test accuracy = %.5f\n',tst_acc);
end

end

