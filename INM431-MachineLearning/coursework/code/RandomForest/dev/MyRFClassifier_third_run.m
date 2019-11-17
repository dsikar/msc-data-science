%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%% Random Forests                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% THIRD RUN
% 1. Convert all columns to categorical
% Result TP = 78, TN = 3, FP = 23, FN = 0, worst so far

% clear environment
clear; clc;

% 1. Load data
cd '\\nsq024vs\u8\aczd097\MyDocs\git\msc-data-science\INM431-MachineLearning\coursework\code\RandomForest\'
trainingData = readtable('../data/student-labelled.csv');

% 2. Convert all to categorical
% inputTable = trainingData;
predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
%predictors = trainingData(:, predictorNames);
%response = trainingData.Result;
% Predictor scheme
isCategoricalPredictor(1,:) = [true, true, false, true, true, true, false, false, true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false];
% In this scheme, we consider only columns "age" and "absences" numerical
isCategoricalPredictor(2,:) = [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false];
addpath('../helper_functions');
trainingData = Table2Categorical(trainingData, isCategoricalPredictor(2,:));

% TODO Add PASS/FAIL canonical column

% 2. Keep models from seeing test data

% Create random index column
trainingData.idx = randn(1, size(trainingData, 1))';
% Keep index  column index
sortIdx = size(trainingData,2); % last column
% Create copy table sorted by index column
tempTDTable = sortrows(trainingData,sortIdx);
% Create the test/train split
rowCount = size(trainingData, 1);
testCount = floor(rowCount/10);
% Test dataset up to and including split point
testingData = tempTDTable(1:testCount,1:sortIdx - 1); % omit index column
% Training dataset beyond split point
trainingData = tempTDTable(testCount+1:end,1:sortIdx - 1);
% Predictors
predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
predictors = trainingData(:, predictorNames);
% Labels
response = trainingData.Result;
response = categorical(response);
X = predictors;
Y = response;
% mdl = fitcensemble(X,Y, 'Method', 'Bag', 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'})
mdl = fitcensemble(X,Y, 'Method', 'Bag', 'OptimizeHyperparameters',{'NumLearningCycles','MaxNumSplits'})
% from >> doc fitcessamble
% General Ensemble Options
% 'Method' — Ensemble aggregation method
% 'Bag' - Bootstrap aggregation (bagging, for example, random forest[2]) — If 'Method' is 'Bag', then fitcensemble uses bagging 
% with random predictor selections at each split (random forest) by default. To use bagging without the random selections, 
% use tree learners whose 'NumVariablesToSample' value is 'all' or use discriminant analysis classifier learners.
% Algorithm used to select the best split predictor at each node, specified as the comma-separated pair 
% consisting of 'PredictorSelection' and a value in this table.
% 'allsplits'	
% Standard CART — Selects the split predictor that maximizes the split-criterion gain over all possible splits of all predictors [1].

% NB 'Learning Rate' cannot be used with 'bagged trees' method 
% fitcensemble(X,Y, 'Method', 'Bag', 'OptimizeHyperparameters',{'NumLearningCycles','MaxNumSplits'})

%%%%%%%%%%%%%%%%
%% Prediction %%
%%%%%%%%%%%%%%%%
Xp = testingData(:, predictorNames);
Yt = testingData.Result;
Yt = categorical(Yt);
mPred = mdl.predict(Xp); % model prediction
%% Accuracy and error
misPred = sum(mPred ~= Yt);
totalObservations = size(Yt);
error = misPred ./ totalObservations;
accuracy = 1 - error(1,1);
%% TP, TN, FP, FN
TP = sum(mPred == '1' & Yt == '1'); % 84
TN = sum(mPred == '0' & Yt == '0'); %  4
FP = sum(mPred == '1' & Yt == '0'); % 14
FN = sum(mPred == '0' & Yt == '1'); %  3
fprintf('TP = %d, TN = %d, FP = %d, FN = %d\n',TP, TN, FP, FN);

% Confusion matrix
figure;
plotconfusion(Yt, mPred);

% save model
save(mdl);

% load compact model
mdl_load = load('mdl.mat');

% repeat prediction
newPred = mdl_load.mdl.predict(Xp);

% generate confusion matrix
figure;
plotconfusion(Yt, mPred);

% generate ROC
[Xroc,Yroc] = perfcurve(Yt,mPred,'pass') 

% start results write up
