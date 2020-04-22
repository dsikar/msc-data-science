%HOG_SVM_prototype_featuresOriginal(digitDatasetPath, HOGPointsSave, cellsize, processSVM)
% Generate HOG-SVM classifier, compute accuracy and plot confusion matrix
%   Inputs:
%   digitDatasetPath - image folder directory path
%   HOGPointsSave - number of points to save
%   cellsize - h x w array size of a HOG cell in pixels
%
%   Note: HOGPointsSave is a function of cellsize. Some valid options:
%   HOGPointsSave = 36; % cellsize [50 50]
%   HOGPointsSave = 324; % cellsize [25 25]
%   HOGPointsSave = 2916; % cellsize [10 10]
%   To determine additional HOGPointsSave values, choose a cellsize, run
%   the function inserting a breakpoint on line:
%           xTrainHOG(:,i) = hog1';
%   Display the size of hog1
%           disp(hog1)
%   Rerun the function with that quantity for HOGPointsSave.
%
%   processSVM - boolean flag, if true, also compute SVM accuracy
%   Outputs: 
%   HOGSVMMdl - SVM classifier
%   HOGSVMAccuracy - SURF SVM classifier accuracy
%   SVMAccuracy - vanilla SVM classifier accuracy
%   Example:
%   [HOGSVMMdl, HOGSVMAccuracy, SVMAccuracy] = ...
%   HOG_SVM_prototype_featuresOriginal('../images/surf_grayscale/', 2916, [10 10], 1)
function [HOGSVMMdl, HOGSVMAccuracy, SVMAccuracy] = HOG_SVM_prototype_featuresOriginal(digitDatasetPath, HOGPointsSave, cellsize, processSVM)

    % Some sections of code adapted from INM460 lab 06.

    SVMAccuracy = 0;

    % digitDatasetPath = '../images/surf_grayscale/';
    imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

    % convert labels from categorical to numeric data, so model may be
    % saved later
    d = string(imds.Labels);
    imds.Labels = double(d);
    
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
    % Points to keep - turned into function arguments
    % HOGPointsSave = 36; % cellsize [50 50]
    % HOGPointsSave = 324; % cellsize [25 25]
    %HOGPointsSave = 2916; % cellsize [10 10]
    %cellsize = [10 10];
    % Vector storage point size x 64 to hold partial featuresOriginal matrix
    xTrainHOG = zeros(HOGPointsSave,numel(imgtrain));
    for i = 1:numel(imgtrain)
        if processSVM == 1
            xTrain(:,i) = imgtrain{i}(:); % (:) effectively stacks all columns
        end
        % extract HOG features
        [hog1,visualization] = extractHOGFeatures(imgtrain{i},'CellSize',cellsize);
        % transpose hog column vector
        xTrainHOG(:,i) = hog1';
    end

    imgtest = readall(xTestImages);
    % Turn the test images into vectors and put them in a matrix
    xTest = zeros(inputSize,numel(imgtest));
    xTestHOG = zeros(HOGPointsSave,numel(imgtest));

    for i = 1:numel(imgtest)
        if processSVM == 1
            xTest(:,i) = imgtest{i}(:);
        end
        % extract HOG features
        [hog1,visualization] = extractHOGFeatures(imgtest{i},'CellSize',cellsize);
        % transpose hog column vector
        xTestHOG(:,i) = hog1';
    end

    SVMMdl = fitcecoc(xTrain',xTrainImages.Labels); %SVM MULTICLASS TRAINER
    % SURF SVM
    HOGSVMMdl = fitcecoc(xTrainHOG',xTrainImages.Labels);
    if processSVM == 1
        labelsOut = predict(SVMMdl,xTest');
    end
    % Predict HOG Labels
    HOGlabelsOut = predict(HOGSVMMdl,xTestHOG');
    if processSVM == 1
        ConfMatTest = confusionmat(xTestImages.Labels,labelsOut);
    end
    % SURF CM
    HOGConfMatTest = confusionmat(xTestImages.Labels,HOGlabelsOut);

    if processSVM == 1
        SVMAccuracy = 1 - (numel(imgtest) - sum(diag(ConfMatTest))) / numel(imgtest)
    end
    HOGSVMAccuracy = 1 - (numel(imgtest) - sum(diag(HOGConfMatTest))) / numel(imgtest)

    % HOG Confusion Matrix
    plotconfusion(categorical(xTestImages.Labels),categorical(HOGlabelsOut));

    % save model
    % saveCompactModel(HOGSVMMdl, 'HOGSVMMdl');
    
end