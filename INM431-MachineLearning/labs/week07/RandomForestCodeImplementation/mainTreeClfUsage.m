% from whatsapp chat:
% regression - try fitrensamble (over treebagger) ~ easier to implement
% kfold
% ROC matworks plotroc.html

% clean environment
close all
clear all
clc

addpath(genpath('libs\'));
%load sampleData;
% x = -20:20;
% y= x.^2;
% read data
y = ReadMatFromFile('toyLabelClf.dat');
x = ReadMatFromFile('toyDataClf.dat');
% count number of samples (table is transposed ~ count number of columns)
numSamples = size(x , 2);

% y = datasample(data,k,dim) returns a sample taken along dimension dim of data.
% y = datasample(___,Name,Value) returns a sample for any of the input arguments 
% in the previous syntaxes, with additional options specified by one or more name-value 
% pair arguments. For example, 'Replace',false specifies sampling without replacement.
% [y,idx] = datasample(___) also returns an index vector indicating which values datasample 
% sampled from data using any of the input arguments in the previous syntaxes.

% In plain english, sample from data y, 320 samples from dimension 2
% (columns), sampling without replacement.
% Keep the index (idx) and discard the sampled data(y).
[~, idx] = datasample(y, 0.8*numSamples, 2, 'Replace', false);
% idx = 

% Columns 1 through 23

%   277   274    58   148 ...
   
% create empty vectors to hold training data and labels
trainingData = []; testingData = [];
trainingLabel = []; testingLabel = [];
% Create a vector of zeros, the size of our data y
partitionMap = zeros(size(y));
% create a partition map, assigning 1 to to all cells sampled e.g. cell
% 277, 274, 58 and 148 will have a value of 1
partitionMap(idx) = 1;
% partitionMap =

%  Columns 1 through 23

%     0     1     1     1 ...

% Split data using partition map
% iterate i from 1 to 400 (total size of data)
for i = 1:size(partitionMap,2)
    if(partitionMap(1,i) == 1) % all 1's (320, 80% of data) is our training set
        trainingData = [trainingData x(:, i)];
        trainingLabel = [trainingLabel y(:, i)];
    else % all 0's (80, 20% of data) is our testing set
        testingData = [testingData x(:, i)];
        testingLabel = [testingLabel y(:, i)];
    end
end
% Another splitting scheme can be found in INM427 Neural Networks week04 lab nnTrain.m, 
% performed with an added index column of random numbers,
% then ordering on random number e.g.
% y = y'
% idx = randn(1, size(y, 1))'
% y(:,size(y,2)+1) = idx
% x = x'
% x(:,size(x,2)+1) = idx
% sort, remove index column and transpose
% y = sortrows(y,size(y,2))
% y = y(:,size(y,2)-1)'
% x = sortrows(x,size(x,2))
% x = x(:,1:size(x,2)-1)'
% Define a split
% d_split = floor(0.8 * size(y,2))
% Create testing and training sets
% trainingData = x(:,1:d_split)
% trainingLabel = y(:,1:d_split)
% testingData = x(:,d_split + 1:end)
% testingLabel = y(:,d_split + 1:end)
% This seems more in line with Matlab's matrix environment

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TRAINING ACCURACY
% Tutorial 7 
% Task 1: Change the number of trees in the forest
myForest = RForestClass(10); % Argument is number of trees
% class(myForest) 
% ans =
%    'RForestClass'
% myForest is a struct with two members:

% Task 2: Change the maximum depth of the trees
% We need to add another parameter to trainRF member function
% myForest.trainRF(trainingData, trainingLabel);
maxDepth = 10;
myForest.trainRF(trainingData, trainingLabel, maxDepth);
outD = [];
pL = [];
for i = 1:size(trainingLabel,2)
    [pLabel, outNode]  = myForest.predictRF(trainingData(:, i));
    outD = [outD; outNode.m_hist(2,:)];
    pL = [pL pLabel];
end

figure('name','Training Data');
scatter3(trainingData(1,:), trainingData(2,:), trainingLabel, 36, [0 0 1]);
hold on;
scatter3(trainingData(1,:), trainingData(2,:), pL, 18, [1 0 0]);
title('Training data');
xlabel('X Attribute 1'); % x-axis label
ylabel('X Attribute 2'); % y-axis label
zlabel('Y'); % z-axis label
legend('Labels', 'Training Classification');
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TESTING ACCURACY

myTree = RTreeClass(20, 10);
myTree.trainTree(trainingData, trainingLabel);
outC = [];
for i = 1:size(testingLabel,2)
    outNode  = myTree.predictTree(testingData(:, i));
    outC = [outC; outNode.m_hist(2,:)];
end

myForest = RForestClass(10);
myForest.trainRF(trainingData, trainingLabel);
outD = [];
pL = [];
for i = 1:size(testingLabel,2)
    [pLabel, outNode]  = myForest.predictRF(testingData(:, i));
    outD = [outD; outNode.m_hist(2,:)];
    pL = [pL pLabel];
end

figure('name','Testing Data');
scatter3(testingData(1,:), testingData(2,:), testingLabel, 36, [0 0 1]);
hold on;
scatter3(testingData(1,:), testingData(2,:), pL, 18, [1 0 0]);
title('Testing data');
xlabel('X Attribute 1'); % x-axis label
ylabel('X Attribute 2'); % y-axis label
zlabel('Y'); % z-axis label
legend('Labels', 'Testing Classification');

hold off;
% need to use keyword (function?) figure before generating confusion
% matrix
figure
cm = confusionchart(testingLabel,pL, ...
    'Title','My Title', ...
    'RowSummary','row-normalized', ...
    'ColumnSummary','column-normalized');


