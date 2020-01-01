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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Best model search START %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FUTURE WORK - Turn into parameterized grid search

% mdl = fitcensemble(X,Y, 'Method', 'Bag', 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'})
% mdl = fitcensemble(X,Y, 'Method', 'Bag', 'OptimizeHyperparameters',{'NumLearningCycles','MaxNumSplits'}) %TP = 78, TN = 5, FP = 14, FN = 7
% mdl = fitcensemble(X,Y,'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'}) % TP = 77, TN = 9, FP = 10, FN = 8
% mdl = fitcensemble(X,Y,'OptimizeHyperparameters','auto') % TP = 80, TN = 6, FP = 13, FN = 5 % still dire
% mdl = fitcensemble(X,Y, 'Method', 'Bag', 'OptimizeHyperparameters',{'NumLearningCycles','MaxNumSplits'}) % TP = 79, TN = 10, FP = 10, FN = 5, best one so far
%mdl = fitcensemble(X,Y, 'Method', 'LogitBoost', 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'}) % no method asked % TP = 79, TN = 17, FP = 3, FN = 5 BEST RESULT SO FAR
% See https://en.wikipedia.org/wiki/LogitBoost - plus references
%mdl = fitcensemble(X,Y, 'Method', 'LogitBoost', 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'},  'HyperparameterOptimizationOptions',struct('MaxObjectiveEvaluations',60)) % TP = 77, TN = 20, FP = 3, FN = 4 % NEW BEST

% mdl = fitcensemble(X,Y, 'Method', 'LogitBoost',
% 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits',
% 'MinLeafSize', 'SplitCriterion', 'NumVariablesToSample'  },
% 'HyperparameterOptimizationOptions',struct('MaxObjectiveEvaluations',60))
% % TP = 78, TN = 16, FP = 6, FN = 4 % DIPPED
% mdl = fitcensemble(X,Y, 'Method', 'LogitBoost', 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'},  'HyperparameterOptimizationOptions',struct('MaxObjectiveEvaluations',80)) % TP = 72, TN = 24, FP = 1, FN = 7 % More MaxObjectiveEvaluations, one off best, might be hitting glass ceiling
% mdl = fitcensemble(X,Y, 'OptimizeHyperparameters',{'Method','NumLearningCycles','LearnRate','MinLeafSize','MaxNumSplits'},  'HyperparameterOptimizationOptions',struct('MaxObjectiveEvaluations',100));
% Best with 40 MaxObjectiveEvaluations instead of 60
% mdl = fitcensemble(X,Y, 'Method', 'LogitBoost', 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'},  'HyperparameterOptimizationOptions',struct('MaxObjectiveEvaluations',40)) % TP = 80, TN = 12, FP = 8, FN = 4 % worse with 40, accuracy [0.884615384615385]
% back to 60
% mdl = fitcensemble(X,Y, 'Method', 'LogitBoost', 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'},  'HyperparameterOptimizationOptions',struct('MaxObjectiveEvaluations',60)) % TP = 78, TN = 14, FP = 9, FN = 3 % 2nd time around, not as good
% mdl = fitcensemble(X,Y, 'Method', 'LogitBoost', 'OptimizeHyperparameters',{'NumLearningCycles','LearnRate','MaxNumSplits'},  'HyperparameterOptimizationOptions',struct('MaxObjectiveEvaluations',100)) % TP = 77, TN = 20, FP = 4, FN = 3 % Best model, save
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Best model search END %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

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