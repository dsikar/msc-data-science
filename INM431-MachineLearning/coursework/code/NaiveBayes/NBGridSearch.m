%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear environment
clear; clc;

% change directory - ADJUST
cd('\\nsq024vs\u8\aczd097\MyDocs\git\msc-data-science\INM431-MachineLearning\coursework\code\NaiveBayes')

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

% TODO - turn into a hyperparameter
%predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
%model_suffix = '';
%predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences','G1'};
%model_suffix = '_G1';
predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences','G1','G2'};
model_suffix = '_G1_G2';


%predictors = trainingData(:, predictorNames);
%response = trainingData.Result;

% 4. Hyperparameters for Naive Bayes model

% Validation schemes
validation = {'KFold', 'KFold', 'KFold', 'KFold', 'Holdout', 'Holdout', 'Holdout', 'Holdout', 'Holdout' 'Holdout', 'Holdout', 'Holdout', 'Holdout'};
vars =   [2 3 4 5 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5];

% Predictor scheme
if (strcmp(model_suffix, '') == 1),
    isCategoricalPredictor(1,:) = [true, true, false, true, true, true, false, false, true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false];
    % In this scheme, we consider only columns "age" and "absences" numerical
    % NB Grades when present are considered numerical
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
    disp_str = strcat('Categorical/Numerical predictor scheme: ', string(k));
    %disp(disp_str);
    isCatPred = isCategoricalPredictor(k,:);
    fixedTrainingData = Table2Categorical(trainingData, isCatPred);
    fixedTestingData = Table2Categorical(testingData, isCatPred);
    testResponse = fixedTestingData.Result;    
    predictors = fixedTrainingData(:, predictorNames);
    response = fixedTrainingData.Result;
    % disp('isCatPredScheme, '); % headers predictorscheme, validation, params, trainingAcc, testingAcc, validationAccuracy, testAccuracy  
    for j = 1:size(vars, 2),  % strcat(string(k), ', ', val, ', ', string(var), ', ', string(validationAccuracy), ', ', string(testAccuracy))
        val = validation(j);
        % disp(val);
        var = vars(j); % convert to character array
        % disp(var);
        [trainedClassifier, validationAccuracy] = ...
        trainNaiveBayesModel(trainingData, predictorNames, ...
        predictors, response, ...
        isCatPred, ...
        val, var);  
        if validationAccuracy > BestTrainAcc,
            BestTrainAcc = validationAccuracy;
            msg = strcat('Best model so far:', ' ', string(BestTrainAcc));
            disp(msg);
            % filename = strcat(...);
            filename = strcat('NB_mdl', model_suffix);
            save(filename); % save workspace
        %   TODO save model e.g. NB_k_j_mdl<_>.mat
        end;
        % Append to table 
        testPredictions = trainedClassifier.predictFcn(fixedTestingData);
        correctTestPredictions = (testPredictions == testResponse);
        testAccuracy = sum(correctTestPredictions)/length(correctTestPredictions);
        % if testAccuracy > BestTestAcc
        %   BestTestAcc = testAccuracy;
        %   save model nb_mdl % append nothing, _G1, _G1_G2 as may be the
        %   case
        % end;      
        %disp(validationAccuracy);
        %disp(testAccuracy);
        %disp('*******');
        msg = strcat(string(k), ', ', val, ', ', string(var), ', ', string(validationAccuracy), ', ', string(testAccuracy), ', ', model_suffix);
        disp(msg);
        % Todo
        % 1. Save results and hyperparameters to grid
        % 2. Define best result with training and testing accuracies
        % 3. Save best model
        % 4. Create README run script for coursework
    end;
end;

%[trainedClassifier, validationAccuracy] = trainNaiveBayesModel(trainingData);
