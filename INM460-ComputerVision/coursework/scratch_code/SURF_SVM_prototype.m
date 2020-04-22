%SURF-SVM prototype
clear all;
clc;

digitDatasetPath = '../images/surf_grayscale/';
imds = imageDatastore(digitDatasetPath, ...
'IncludeSubfolders',true,'LabelSource','foldernames');

% [imdsTrain,imdsValidation] = splitEachLabel(imds,0.75,'randomized');
[xTrainImages, xTestImages] = splitEachLabel(imds,0.80,'randomized');

% Load the training data into memory
% [xTrainImages, tTrain] = digittrain_dataset;
% Display some of the training images
clf
for i = 6:25
    subplot(4,5,i-5);
    % imshow(xTrainImages{i});
    imshow(xTrainImages.readimage(i));
end

% Get the number of pixels in each image
[imageWidth, imageHeight] = size(xTrainImages.readimage(i));
%imageWidth = 100;
%imageHeight = 100;
inputSize = imageWidth*imageHeight; % Load the test images
% read all images
imgtrain = readall(xTrainImages);
% Turn the training images into vectors and put them in a matrix
xTrain = zeros(inputSize,numel(imgtrain));
% Points to keep 
SURFPointsSave = 15;
% Vector storage point size doubled to store as vector
xTrainSURF = zeros(SURFPointsSave*2,numel(imgtrain));
for i = 1:numel(imgtrain)
    xTrain(:,i) = imgtrain{i}(:); % (:) effectively stacks all columns
    % detect Speeded-Up Robust Features
    points = detectSURFFeatures(imgtrain{i}, 'MetricThreshold', 500, 'NumOctaves', 1 , 'NumScaleLevels', 6);
    % Extract features, do not estimate orientation of the feature
    % vectors.
    [featuresOriginal,validPtsOriginal] = extractFeatures(imgtrain{i},points, 'Upright',true);
    strongPoints = selectStrongest(validPtsOriginal,SURFPointsSave);
    xTrainSURF(:,i) = strongPoints.Location(:);
end

imgtest = readall(xTestImages);
% Turn the test images into vectors and put them in a matrix
xTest = zeros(inputSize,numel(imgtest));
xTestSURF = zeros(SURFPointsSave*2,numel(imgtest));

for i = 1:numel(imgtest)
    xTest(:,i) = imgtest{i}(:);
    points = detectSURFFeatures(imgtest{i}, 'MetricThreshold', 500, 'NumOctaves', 1 , 'NumScaleLevels', 6);
    % Extract features, do not estimate orientation of the feature
    % vectors.
    [featuresOriginal,validPtsOriginal] = extractFeatures(imgtest{i},points, 'Upright',true);
    strongPoints = selectStrongest(validPtsOriginal,SURFPointsSave);
    xTestSURF(:,i) = strongPoints.Location(:);
end

SVMMdl = fitcecoc(xTrain',xTrainImages.Labels); %SVM MULTICLASS TRAINER
% SURF SVM
SURFSVMMdl = fitcecoc(xTrainSURF',xTrainImages.Labels);
labelsOut = predict(SVMMdl,xTest');
% Predict SURF Labels
SURFlabelsOut = predict(SURFSVMMdl,xTestSURF');
ConfMatTest = confusionmat(xTestImages.Labels,labelsOut);
% SURF CM
SURFConfMatTest = confusionmat(xTestImages.Labels,SURFlabelsOut);

Accuracy = 1 - (numel(imgtest) - sum(diag(ConfMatTest))) / numel(imgtest)
SURFAccuracy = 1 - (numel(imgtest) - sum(diag(SURFConfMatTest))) / numel(imgtest)

plotconfusion(xTestImages.Labels,labelsOut);
% SURF Confusion Matrix
plotconfusion(xTestImages.Labels,SURFlabelsOut);