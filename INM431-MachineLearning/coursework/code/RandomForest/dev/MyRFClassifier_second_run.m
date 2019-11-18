%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%% Random Forests                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SECOND RUN
% 1. response labels as 'categorical'
% 2. worse than first fun

% clear environment
clear; clc;

% 1. Load data

trainingData = readtable('student-labelled.csv');

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
% TODO - change all to categorical - fitcensemble does not seem to use
% numerical columns
predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
predictors = trainingData(:, predictorNames);
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
TP = sum(mPred == 1 & Yt == 1); % 84
TN = sum(mPred == 0 & Yt == 0); %  4
FP = sum(mPred == 1 & Yt == 0); % 14
FN = sum(mPred == 0 & Yt == 1); %  3

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
