%SURF_SVM_prototype_featuresOriginal(digitDatasetPath, SURFPointsSave, processSVM)
% Generate SURF-SVM classifier, compute accuracy and plot confusion matrix
%   Inputs:
%   digitDatasetPath - image folder directory path
%   SURFPointsSave - number of feature vector rows to use
%   processSVM - boolean flag, if true, also compute SVM accuracy
%   Outputs: 
%   SURFSVMMdl - SVM classifier
%   SURFSVMAccuracy - SURF SVM classifier accuracy
%   SVMAccuracy - vanilla SVM classifier accuracy
%   Example:
%   [SURFSVMMdl, SURFSVMAccuracy, SVMAccuracy] = ...
%   SURF_SVM_prototype_featuresOriginal('../images/surf_grayscale/', 30, 1)
function [SURFSVMMdl, SURFSVMAccuracy, SVMAccuracy] = SURF_SVM_prototype_featuresOriginal(digitDatasetPath, SURFPointsSave, processSVM)

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
    % Points to keep 
    % SURFPointsSave = 50;
    % columns we need to keep
    featuresColNo = 64;
    % Vector storage point size x 64 to hold partial featuresOriginal matrix
    xTrainSURF = zeros(SURFPointsSave*featuresColNo,numel(imgtrain));
    for i = 1:numel(imgtrain)
        if processSVM == 1
            xTrain(:,i) = imgtrain{i}(:); % (:) effectively stacks all columns
        end
        % detect Speeded-Up Robust Features
        points = detectSURFFeatures(imgtrain{i}, 'MetricThreshold', 500, 'NumOctaves', 1 , 'NumScaleLevels', 6);
        % Extract features, do not estimate orientation.
        [featuresOriginal,validPtsOriginal] = extractFeatures(imgtrain{i},points, 'Upright',true);
        %strongPoints = selectStrongest(validPtsOriginal,SURFPointsSave);
        % get the size
        [rows cols] = size(featuresOriginal);
        % save
        f = featuresOriginal(1:rows,:);
        if SURFPointsSave <= rows
            % drop rows/reshape feature vector
            f = f(1:SURFPointsSave,:);
            % flag
            msg = strcat('Index ', string(i), " has ", string(rows), " feature vector rows.");
            disp(msg)
        else
            % pad missing rows with zeros
            padsize = SURFPointsSave - rows;
            f = [f; zeros(padsize,featuresColNo)];
        end
        % f = featuresOriginal(1:SURFPointsSave,:);
        xTrainSURF(:,i) = f(:);
    end

    imgtest = readall(xTestImages);
    % Turn the test images into vectors and put them in a matrix
    xTest = zeros(inputSize,numel(imgtest));
    xTestSURF = zeros(SURFPointsSave*64,numel(imgtest));

    for i = 1:numel(imgtest)
        if processSVM == 1
            xTest(:,i) = imgtest{i}(:);
        end
        points = detectSURFFeatures(imgtest{i}, 'MetricThreshold', 500, 'NumOctaves', 1 , 'NumScaleLevels', 6);
        % Extract features, do not estimate orientation of the feature
        % vectors.
        [featuresOriginal,validPtsOriginal] = extractFeatures(imgtest{i},points, 'Upright',true);

        % get the size
        [rows cols] = size(featuresOriginal);
        % save
        f = featuresOriginal(1:rows,:);
        if SURFPointsSave <= rows
            % reshape save
            f = f(1:SURFPointsSave,:);
            % flag
            msg = strcat("Index ", string(i), " has ", string(rows), " feature rows.");
            disp(msg)
        else
            % pad with zeros
            padsize = SURFPointsSave - rows;
            f = [f; zeros(padsize,featuresColNo)];
        end
        % f = featuresOriginal(1:SURFPointsSave,:);
        xTestSURF(:,i) = f(:);
    end

    SVMMdl = fitcecoc(xTrain',xTrainImages.Labels); %SVM MULTICLASS TRAINER
    % SURF SVM
    SURFSVMMdl = fitcecoc(xTrainSURF',xTrainImages.Labels);
    if processSVM == 1
        labelsOut = predict(SVMMdl,xTest');
    end
    % Predict SURF Labels
    SURFlabelsOut = predict(SURFSVMMdl,xTestSURF');
    if processSVM == 1
        ConfMatTest = confusionmat(xTestImages.Labels,labelsOut);
    end
    % SURF CM
    SURFConfMatTest = confusionmat(xTestImages.Labels,SURFlabelsOut);

    if processSVM == 1
        SVMAccuracy = 1 - (numel(imgtest) - sum(diag(ConfMatTest))) / numel(imgtest)
    end
    SURFSVMAccuracy = 1 - (numel(imgtest) - sum(diag(SURFConfMatTest))) / numel(imgtest)

    % SURF Confusion Matrix
    plotconfusion(categorical(xTestImages.Labels),categorical(SURFlabelsOut));

    % saveCompactModel(SURFSVMMdl, 'SURFSVMMdl');
    
end