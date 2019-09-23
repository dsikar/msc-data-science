% clear all
clear all;
% load 
data = readtable("iris.txt",'ReadVariableNames', false);
VarNames = ["sepal_length","sepal_width","petal_length","petal_width","iris_class"];
data.Properties.VariableNames = VarNames;
c = cvpartition(data.iris_class,'Holdout',0.3)
trainingData = data(training(c),:)
testData = data(test(c),:)
ctree = fitctree(trainingData, 'iris_class')
view(ctree,'Mode','graph')
predictedLabel = predict(ctree, testData)
testDataLabels = testData(:,5)

predicted = string(predictedLabel)
actual = string(testDataLabels.iris_class)
wrongPredictions = predicted ~= actual
sum(wrongPredictions)
% 4