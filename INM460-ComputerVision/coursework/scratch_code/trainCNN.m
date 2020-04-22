% From Lab 8 - CNNs and OCR
clear all; clc;

% Specify Training and Validation Sets
numTrainFiles = 100; % 323; % 438; % case - 20 images for each label - THIS WILL CHANGE AS WE GET MORE DATA
p = numTrainFiles * 0.7;
p = round(p);
numChannels = 3;

% digitDatasetPath = '../images/IndividualGrayscale100x100/';
digitDatasetPath = '../images/sandbox_output227x227/';
imds = imageDatastore(digitDatasetPath, ...
'IncludeSubfolders',true,'LabelSource','foldernames');
imagesLoaded = 1;
%end

% Calculate the number of images in each category
labelCount = countEachLabel(imds);
% Get a total to randomly choose from
totalCount =  sum(table2array(labelCount(:,2)));
% Get a class count
classCount = size(labelCount.Label);
% Convert row count to integer
classCount = int8(classCount(1));

% Display some of the images in the datastore.
figure;
perm = randperm(totalCount,20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end

% Check the size of the first image in digitData
img = readimage(imds,1);
[rows cols] = size(img);

% help splitEachLabel
[imdsTrain,imdsValidation] = splitEachLabel(imds,p,'randomized');

% Define the convolutional neural network architecture.
layers = [
    imageInputLayer([rows rows numChannels])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(classCount)
    softmaxLayer
    classificationLayer];

% Specify Training Options % increasing number of epochs
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'ExecutionEnvironment','cpu', ...
    'Plots','training-progress');

% Train Network Using Training Data
net = trainNetwork(imdsTrain,layers,options);

% Classify Validation Images and Compute Accuracy
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;
accuracy = sum(YPred == YValidation)/numel(YValidation) 

% save network
dan_net4 = net;
save dan_net4