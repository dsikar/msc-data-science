%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [trainedClassifier, validationAccuracy] = trainNaiveBayesModel(trainingData, predictorNames, ...
        preds, resp, ...
        isCatPred, ...
        val, var)
% trainedClassifier = trainingData/1;
% validationAccuracy = trainingData/2;
% Which attributes are categorical?
% Reference states that majority are binary.
% For our matlab models, we will threat the majority of columns as
% categorical, except "age" and "absences". The reason being most numeric
% attributes denote categories.

 %                           {'school', 'sex', 'age',  'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
 % from readme                binary:   binary numeric binary     binary     binary         
 % isCategoricalPredictor = [ true,     true,  false,  true,      true,       true,     false,   false,  true,   true,   true,     true,      false,        false,       false,       true,        true,     true,    true,       true,      true,     true,       true,       false,     false,     false,    false,  false,  false,    false];
 
 % [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: a table containing the same predictor and response
%       columns as imported into the app.
%
%  Output:
%      trainedClassifier: a struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: a function to make predictions on new
%       data.
%
%      validationAccuracy: a double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
%inputTable = trainingData;
%predictorNames = {'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
%predictors = inputTable(:, predictorNames);
%response = inputTable.Result;
%isCategoricalPredictor = [true, true, false, true, true, true, false, false, true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.

if val == "Holdout",
    % adjust parameters
    % Set up holdout validation
    cvp = cvpartition(resp, 'Holdout', var);
    preds = preds(cvp.training, :);
    resp = resp(cvp.training, :);
end;

% Expand the Distribution Names per predictor
% Numerical predictors are assigned either Gaussian or Kernel distribution and categorical predictors are assigned mvmn distribution
% Gaussian is replaced with Normal when passing to the fitcnb function
distributionNames =  repmat({'Normal'}, 1, length(isCatPred));
distributionNames(isCatPred) = {'mvmn'}; % multivariate binary polinomial

% todo change class names to "pass", "fail"
classificationNaiveBayes = fitcnb(preds, resp, ...
    'DistributionNames', distributionNames, ...
    'ClassNames', [0; 1]);

% Add result to struct
trainedClassifier.ClassificationNaiveBayes = classificationNaiveBayes;

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
naiveBayesPredictFcn = @(x) predict(classificationNaiveBayes, x);
trainedClassifier.predictFcn = @(x) naiveBayesPredictFcn(predictorExtractionFcn(x));

if val == "Holdout",
    % Compute validation predictions
    validationPredictors = preds; % preds(cvp.test, :);
    validationResponse = resp; % resp(cvp.test, :);
    [validationPredictions, validationScores] = trainedClassifier.predictFcn(validationPredictors);
    % Compute validation accuracy
    correctPredictions = (validationPredictions == validationResponse);
    isMissing = isnan(validationResponse);
    correctPredictions = correctPredictions(~isMissing);
    validationAccuracy = sum(correctPredictions)/length(correctPredictions);
else % KFold
    % Perform cross-validation
    partitionedModel = crossval(trainedClassifier.ClassificationNaiveBayes, cell2mat(val), var); % 
    % Compute validation predictions
    [validationPredictions, validationScores] = kfoldPredict(partitionedModel);
    % Compute validation accuracy
    validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
end;

