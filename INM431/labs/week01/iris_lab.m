% clear all
clear all;
% load 
data = readtable("iris.txt",'ReadVariableNames', false);
% set column names
VarNames = ["sepal_length","sepal_width","petal_length","petal_width","iris_class"];
data.Properties.VariableNames = VarNames;
% add a row index 
%row_nos = height(data)
%rowidx = linspace(1,row_nos,row_nos) % rowidx has 150 columns and one row
%data.idx = rowidx'; % transpose rowidx to match data rows
% partition data for training and testing
c = cvpartition(data.iris_class,'Holdout',0.3);
trainingData = data(training(c),:);
testData = data(test(c),:);
% counts to evaluate partition
dataSums = varfun(@sum,data,'GroupingVariable','iris_class');
dataSums(:,1:2);
trainingSums = varfun(@sum,trainingData,'GroupingVariable','iris_class');
trainingSums(:,1:2);
testingSums = varfun(@sum,testData,'GroupingVariable','iris_class');
testingSums(:,1:2);
ctree = fitctree(trainingData, 'iris_class'); % doc fitctree
view(ctree,'Mode','graph');
predictedLabel = predict(ctree, testData);
testDataLabels = testData(:,5);

predicted = string(predictedLabel);
actual = string(testDataLabels.iris_class);
wrongPredictions = predicted ~= actual;
sum(wrongPredictions)
% 4



