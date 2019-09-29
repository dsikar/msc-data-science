% INM431 Machine Learning
% Week 1 Decision trees
% https://moodle.city.ac.uk/mod/resource/view.php?id=1422696

% clear all
clear all;
% clear command window
clc;
% save data as iris.txt to local matlab path
% http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data

data = readtable("iris.txt",'ReadVariableNames', false); % ending semicolon, suppresses output
% Substituted single for double quotes to get this to work on lab computers
VarNames = ["sepal_length","sepal_width","petal_length","petal_width","iris_class"];
data.Properties.VariableNames = VarNames;
% From
% >> doc cvpartition
% cvpartition(n,'HoldOut',p) creates a random nonstratified partition for holdout validation on n observations. 
% This partition divides the observations into a training set and a test (or holdout) set. The parameter p 
% must be a scalar. When 0 < p < 1, cvpartition randomly selects approximately p*n observations for the test set. 
% When p is an integer, cvpartition randomly selects p observations for the test set. The default value of p is 1/10.
c = cvpartition(data.iris_class,'Holdout',0.3); 
% From
% >> doc training
% idx = training(c) returns the logical vector idx of training indices for an object c of the 
% cvpartition class of type 'holdout' or 'resubstitution'.
trainingData = data(training(c),:); % all rows where training(c) == 1, all columns
% From
% >> doc test
% idx = test(c) returns the logical vector idx of test indices for an object c of the 
% cvpartition class of type 'holdout' or 'resubstitution'.
testData = data(test(c),:); % all rows where test(c) == 1, all columns
% From 
% >> doc fitctree
% tree = fitctree(Tbl,ResponseVarName) returns a fitted binary classification decision tree based on the input variables 
% (also known as predictors, features, or attributes) contained in the table Tbl and output (response or labels) contained 
% in ResponseVarName. The returned binary tree splits branching nodes based on the values of a column of Tbl.
ctree = fitctree(trainingData, 'iris_class');
% From
% https://uk.mathworks.com/help/stats/compactclassificationtree.view.html
% view(tree,Name,Value) describes tree with additional options specified by one or more Name,Value pair arguments.
view(ctree,'Mode','graph')
% Text (default) mode produces:
% >> view(ctree,'Mode','text')

% Decision tree for classification
% 1  if petal_length<2.45 then node 2 elseif petal_length>=2.45 then node 3 else Iris-setosa
% 2  class = Iris-setosa
% 3  if petal_length<4.85 then node 4 elseif petal_length>=4.85 then node 5 else Iris-versicolor
% 4  if petal_width<1.65 then node 6 elseif petal_width>=1.65 then node 7 else Iris-versicolor
% 5  class = Iris-virginica
% 6  class = Iris-versicolor
% 7  class = Iris-virginica

% Compute the classification error
% From
% https://uk.mathworks.com/help/stats/compactclassificationensemble.loss.html

disp("Classification error (loss):")
l = loss(ctree, testData, 'iris_class');
disp(l)

% To finish off, let's test different holdout (hyperparameter) values 
for h = 0.9:-0.1:0.1
   c = cvpartition(data.iris_class,'Holdout',h);
   trainingData = data(training(c),:);
   testData = data(test(c),:);
   ctree = fitctree(trainingData, 'iris_class');
   l = loss(ctree, testData, 'iris_class');
   result = strcat("Holdout: ",string(h),", loss: ", string(l));  
   disp(result)
end

% Future work
% 1. Store best model

% Appendix
% Computing the loss "manually"
% predictedLabel = predict(ctree, testData);
% testDataLabels = testData(:,5)
% predicted = string(predictedLabel)
% actual = string(testDataLabels.iris_class)
% wrongPredictions = predicted ~= actual
% sum(wrongPredictions)
% 4