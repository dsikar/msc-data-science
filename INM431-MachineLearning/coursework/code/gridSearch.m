%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear environment
clear; clc;

% 1. Load data

trainingData = readtable('student-labelled.csv');

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

% 3. Table columns and data types

% inputTable = trainingData;
predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
%predictors = trainingData(:, predictorNames);
%response = trainingData.Result;

% 4. Hyperparameters for Naive Bayes model

% Validation schemes
validation = {'KFold', 'KFold', 'KFold', 'KFold', 'Holdout', 'Holdout', 'Holdout', 'Holdout', 'Holdout' 'Holdout', 'Holdout', 'Holdout', 'Holdout'};
vars =   [2 3 4 5 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5];

% Predictor scheme
isCategoricalPredictor(1,:) = [true, true, false, true, true, true, false, false, true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false];
% In this scheme, we consider only columns "age" and "absences" numerical
isCategoricalPredictor(2,:) = [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false];

% 5. Grid search - find and save best model

for k = 1:size(isCategoricalPredictor, 1), 
    % if k = 2 // convert table
    isCatPred = isCategoricalPredictor(k,:);
    fixedTrainingData = Table2Categorical(trainingData, isCatPred);
    fixedTestingData = Table2Categorical(testingData, isCatPred);
    testResponse = fixedTestingData.Result;    
    predictors = fixedTrainingData(:, predictorNames);
    response = fixedTrainingData.Result;
    disp('*******New Categorical Predictors*******');    
    for j = 1:size(vars, 2), 
        val = validation(j);
        var = vars(j); % convert to character array
        [trainedClassifier, validationAccuracy] = ...
        trainNaiveBayesModel(trainingData, predictorNames, ...
        predictors, response, ...
        isCatPred, ...
        val, var);      
        testPredictions = trainedClassifier.predictFcn(fixedTestingData);
        correctTestPredictions = (testPredictions == testResponse);
        testAccuracy = sum(correctTestPredictions)/length(correctTestPredictions);
        disp(validationAccuracy);
        disp(testAccuracy);
        disp('*******');
    end;
end;
    
%[trainedClassifier, validationAccuracy] = trainNaiveBayesModel(trainingData);
