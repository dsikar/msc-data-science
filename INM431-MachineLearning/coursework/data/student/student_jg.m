% Judith Grieves' predictor
clear all;
data = readtable('student-por.csv', 'Delimiter',';');
head(data,5)
%,'Format','%s%s%u%s%s%s%u%u%s%s%s%s%u%u%u%s%s%s%s%s%s%s%s%u%u%u%u%u%u%u%u%u%u'

%VarNames = {'sepal_length' 'sepal_width','petal_length','petal_width','iris_class'};
%data.Properties.VariableNames = VarNames;


% extract the predictor variables from the file data
ds = data(:,{'G3','G2','age','Medu','failures','higher'});
convertvars(ds,'G2','string')
convertvars(ds,'G2','categorical')
% convert vars to binary
ds.G3 = ds.G3 > 10
ds.failures = ds.failures > 0
ds.Medu = ds.Medu > 1
ds.age = ds.age > 18
%ds.G2 = ds.G2 in ['11','12']
% problem with cell types!!!

% create training and test data
c = cvpartition(ds.G3, 'Holdout',0.3)
trainingData = ds(training(c),:)
testData = ds(test(c),:)

%checkdata = [testData,ds(test(c),:)]
%histogram(data.G3);
%boxplot(data.G3,data.sex);
ctree = fitctree(ds,'G3')
view(ctree, 'Mode','graph')
label = predict(ctree, testData)
%checkdata = [testData,label]
cat(2,label,testData)