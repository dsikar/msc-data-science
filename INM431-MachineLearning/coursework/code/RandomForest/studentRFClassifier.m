%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%% Random Forests                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Best model

% clear environment
clear; clc;

% Load data
trainingData = readtable('student-labelled.csv');

% Split data - create random index column
trainingData.idx = randn(1, size(trainingData, 1))';
% Keep index-column index
sortIdx = size(trainingData,2); % last column
% Create copy table sorted by index column
tempTDTable = sortrows(trainingData,sortIdx);
% Create the test/train split
rowCount = size(trainingData, 1);
testCount = floor(rowCount/10); % 10%
% Create test dataset up to and including split point, omitting index col
testingData = tempTDTable(1:testCount,1:sortIdx - 1); 
% Training dataset beyond split point
trainingData = tempTDTable(testCount+1:end,1:sortIdx - 1);
% Test cases, including and excluding term grade columns G1 and G2
% predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences', 'G1', 'G2'};
% predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences', 'G1'};
predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
predictors = trainingData(:, predictorNames);
response = trainingData.Result;
response = categorical(response);
X = predictors;
Y = response;
% Best model 
mdl = fitcensemble(X,Y, 'Method', 'LogitBoost', 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'},  'HyperparameterOptimizationOptions',struct('MaxObjectiveEvaluations',100))

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
save mdl;