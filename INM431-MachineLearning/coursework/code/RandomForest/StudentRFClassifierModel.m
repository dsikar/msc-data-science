%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%% Random Forests                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Best model for Random Forest Classification

% clear environment
clear; clc;

% load model
mdl_load = load('mdl_G1_G2.mat');

% generate predictions
% Test data
testPred = mdl_load.mdl.predict(mdl_load.Xp);
% Train data
trainPred = mdl_load.mdl.predict(mdl_load.predictors);

% generate confusion matrices
figure;
plotconfusion(mdl_load.Y, trainPred, 'RF Student Pass/Fail Train Data G1,G2');

figure;
plotconfusion(mdl_load.Yt, testPred, 'RF Student Pass/Fail Test Data G1,G2');
clear;
% load model
mdl_load = load('mdl_G1.mat');

% generate predictions
% Test data
testPred = mdl_load.mdl.predict(mdl_load.Xp);
% Train data
trainPred = mdl_load.mdl.predict(mdl_load.predictors);

% generate confusion matrices
figure;
plotconfusion(mdl_load.Y, trainPred, 'RF Student Pass/Fail Train Data G1');

figure;
plotconfusion(mdl_load.Yt, testPred, 'RF Student Pass/Fail Test Data G1');
clear;
% load model
mdl_load = load('mdl.mat');

% generate predictions
% Test data
testPred = mdl_load.mdl.predict(mdl_load.Xp);
% Train data
trainPred = mdl_load.mdl.predict(mdl_load.predictors);

% generate confusion matrices
figure;
plotconfusion(mdl_load.Y, trainPred, 'RF Student Pass/Fail Train Data');

figure;
plotconfusion(mdl_load.Yt, testPred, 'RF Student Pass/Fail Test Data');
