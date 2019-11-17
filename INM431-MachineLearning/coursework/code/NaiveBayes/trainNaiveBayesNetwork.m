function [trainedClassifier, validationAccuracy] = trainNaiveBayesNetwork(trainingData)
trainedClassifier = trainingData/1;
validationAccuracy = trainingData/2;
% Which attributes are categorical?
% Reference states that majority are binary.
% For our matlab models, we will threat the majority of columns as
% categorical, except "age" and "absences". The reason being most numeric
% attributes denote categories.

 %                           {'school', 'sex', 'age',  'address', 'famsize', 'Pstatus', 'Medu', 'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime', 'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences'};
 % from readme                binary:   binary numeric binary     binary     binary         
 % isCategoricalPredictor = [ true,     true,  false,  true,      true,       true,     false,   false,  true,   true,   true,     true,      false,        false,       false,       true,        true,     true,    true,       true,      true,     true,       true,       false,     false,     false,    false,  false,  false,    false];