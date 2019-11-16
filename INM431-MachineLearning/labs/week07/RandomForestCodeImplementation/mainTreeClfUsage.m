% from whatsapp chat:
% regression - try fitrensamble (over treebagger) ~ easier to implement
% kfold
% ROC matworks plotroc.html


close all
clear all
clc

addpath(genpath('libs\'));
%load sampleData;
% x = -20:20;
% y= x.^2;

y = ReadMatFromFile('toyLabelClf.dat');
x = ReadMatFromFile('toyDataClf.dat');

numSamples = size(x, 2);

[~, idx] = datasample(y, 0.8*numSamples, 2, 'Replace', false);

trainingData = []; testingData = [];
trainingLabel = []; testingLabel = [];
partitionMap = zeros(size(y));
partitionMap(idx) = 1;


for i = 1:size(partitionMap,2)
    if(partitionMap(1,i) == 1)
        trainingData = [trainingData x(:, i)];
        trainingLabel = [trainingLabel y(:, i)];
    else
        testingData = [testingData x(:, i)];
        testingLabel = [testingLabel y(:, i)];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TRAINING ACCURACY

myForest = RForestClass(10);
myForest.trainRF(trainingData, trainingLabel);
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


