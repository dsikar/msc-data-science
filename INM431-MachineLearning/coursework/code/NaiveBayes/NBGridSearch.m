%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear environment
clear; clc;

% change directory - ***ADJUST***
% cd('\\nsq024vs\u8\aczd097\MyDocs\git\msc-data-science\INM431-MachineLearning\coursework\code\NaiveBayes')

% 1. Load data - all sub-directories below coursework directory must be added

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

% Future work - turn into a hyperparameter, for now, comment in turn
%predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
%model_suffix = '';
%predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences','G1'};
%model_suffix = '_G1';
predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences','G1','G2'};
model_suffix = '_G1_G2'; % both high correlation columns, previous exam results

% 4. Hyperparameters for Naive Bayes model

% Cross-validation schemes
validation = {'KFold', 'KFold', 'KFold', 'KFold', 'Holdout', 'Holdout', 'Holdout', 'Holdout', 'Holdout' 'Holdout', 'Holdout', 'Holdout', 'Holdout'};
vars =   [2 3 4 5 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5];

% Predictor scheme - mostly categorical or mostly numeric attributes
if (strcmp(model_suffix, '') == 1),
    % Original data types, as matlab converted to implicitly, just being
    % explicit to make sures
    isCategoricalPredictor(1,:) = [true, true, false, true, true, true, false, false, true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false];
    % In this scheme, we consider only columns "age" and "absences" numeric
    % NB Grades when present are considered numeric
    isCategoricalPredictor(2,:) = [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false];
end;

if (strcmp(model_suffix, '_G1') == 1),
    isCategoricalPredictor(1,:) = [true, true, false, true, true, true, false, false, true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false];
    isCategoricalPredictor(2,:) = [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false];
end;

if (strcmp(model_suffix, '_G1_G2') == 1),
    isCategoricalPredictor(1,:) = [true, true, false, true, true, true, false, false, true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false];
    isCategoricalPredictor(2,:) = [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false];
end;

% 5. Grid search - find and save best model
predScheme = 1; % we are looking at rows
BestTrainAcc = 0;
TestAcc = 0;
for k = 1:size(isCategoricalPredictor, predScheme), 
    % if k = 2 // convert table
    disp_str = strcat('Categorical/Numeric predictor scheme: ', string(k));
    %disp(disp_str);
    isCatPred = isCategoricalPredictor(k,:);
    fixedTrainingData = Table2Categorical(trainingData, isCatPred); % function defined in helper_functions
    fixedTestingData = Table2Categorical(testingData, isCatPred);
    testResponse = fixedTestingData.Result;    
    predictors = fixedTrainingData(:, predictorNames);
    response = fixedTrainingData.Result; 
    for j = 1:size(vars, 2),  
        val = validation(j);
        var = vars(j); 
        [trainedClassifier, validationAccuracy] = ...
        trainNaiveBayesModel(trainingData, predictorNames, ...
        predictors, response, ...
        isCatPred, ...
        val, var);  
        if validationAccuracy > BestTrainAcc,
            BestTrainAcc = validationAccuracy;
            msg = strcat('Best model so far:', ' ', string(BestTrainAcc));
            disp(msg);
            filename = strcat('NB_mdl', model_suffix);
            save(filename); % save workspace
        end;
        testPredictions = trainedClassifier.predictFcn(fixedTestingData);
        correctTestPredictions = (testPredictions == testResponse);
        testAccuracy = sum(correctTestPredictions)/length(correctTestPredictions);
		% Grid Search
        msg = strcat(string(k), ', ', val, ', ', string(var), ', ', string(validationAccuracy), ', ', string(testAccuracy), ', ', model_suffix);
        disp(msg);
    end;
end;
