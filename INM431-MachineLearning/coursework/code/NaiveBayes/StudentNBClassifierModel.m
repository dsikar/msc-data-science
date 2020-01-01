%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%% Naive Bayes                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Best models for Naive Bayes Classification

% clear environment
clear; clc;

% load model
mdl_load = load('NB_mdl_G1_G2.mat');

% generate predictions

% Train data
Y = mdl_load.trainedClassifier.ClassificationNaiveBayes.Y;
trainPred = mdl_load.trainedClassifier.predictFcn(mdl_load.trainedClassifier.ClassificationNaiveBayes.X);
trainPred = categorical(trainPred);
Y = categorical(Y);

% generate confusion matrix
figure;
plotconfusion(Y, trainPred, 'NB Student Pass/Fail Train Data G1,G2');

% load model
mdl_load = load('NB_mdl_G1.mat');

% generate predictions

% Train data
Y = mdl_load.trainedClassifier.ClassificationNaiveBayes.Y;
trainPred = mdl_load.trainedClassifier.predictFcn(mdl_load.trainedClassifier.ClassificationNaiveBayes.X);
trainPred = categorical(trainPred);
Y = categorical(Y);

% generate confusion matrix
figure;
plotconfusion(Y, trainPred, 'NB Student Pass/Fail Train Data G1');

% load model
mdl_load = load('NB_mdl.mat');

% generate predictions

% Train data
Y = mdl_load.trainedClassifier.ClassificationNaiveBayes.Y;
trainPred = mdl_load.trainedClassifier.predictFcn(mdl_load.trainedClassifier.ClassificationNaiveBayes.X);
trainPred = categorical(trainPred);
Y = categorical(Y);

% generate confusion matrix
figure;
plotconfusion(Y, trainPred, 'NB Student Pass/Fail Train Data');
