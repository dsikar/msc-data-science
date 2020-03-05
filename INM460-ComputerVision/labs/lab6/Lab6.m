% LAB 6
% Perform classification on images using support vector machines and 
% cascading classifiers

% clear the environment
clear all;
clc;

% Load the training data into memory
[xTrainImages, tTrain] = digittrain_dataset; % help digittrain_dataset
% Display some of the training images
clf
for i = 1:20
    subplot(4,5,i);
    imshow(xTrainImages{i});
end

% Get the number of pixels in each image
imageWidth = 28;
imageHeight = 28;
inputSize = imageWidth*imageHeight; % Load the test images

% Turn the training images into vectors and put them in a matrix
xTrain = zeros(inputSize,numel(xTrainImages));
for i = 1:numel(xTrainImages)
    xTrain(:,i) = xTrainImages{i}(:);
end

[xTestImages, tTest] = digittest_dataset; % help digittest_dataset
% Turn the test images into vectors and put them in a matrix
xTest = zeros(inputSize,numel(xTestImages));
for i = 1:numel(xTestImages)
    xTest(:,i) = xTestImages{i}(:);
end

% We can change the format of the labels to 1-10 for simplicity in viewing 
% the labels:
for i = 1 : 5000
    tTrainLabels(i) = uint8(find(tTrain(:,i)));
    tTestLabels(i) = uint8(find(tTest(:,i)));
end

% Then we need to define a multiclass support vector machine using our 
% training data and their labels:
SVMMdl = fitcecoc(xTrain',tTrainLabels); %SVM MULTICLASS TRAINER

% We can use function ‘predict’ to evaluate the performance of the 
% classifier on the training or test images and look at the confusion 
% matrix:
labelsOut = predict(SVMMdl,xTest');
ConfMatTest = confusionmat(tTestLabels,uint8(labelsOut));
Accuracy = 1 - (5000 - sum(diag(ConfMatTest))) / 5000
disp(Accuracy);
% What accuracy do you get?

% Task 2: Testing the Viola-Jones object detector

% Example 1:  Face detection
% ----------------------------        
faceDetector = vision.CascadeObjectDetector; % Default: finds faces 

I = imread('Class.jpg');
bboxes = step(faceDetector, I); % Detect faces

% Annotate detected faces
IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face'); 
I = IFaces;
%figure, imshow(IFaces), title('Detected faces'); 

[rows, cols] = size(bboxes);

% indexes
img_xmin = 1;
img_ymin = 2;
img_width = 3;
img_height = 4;

% loop through all image coordinates
for j=1:rows
    face_rect=bboxes(j,:);
    % crop image at given coordinates
    subImage = imcrop(I, face_rect);
    % kernel
    H = fspecial('disk',30);
    % apply filter and save image
    blurred = imfilter(subImage,H);
    
    % edit filtered image into original
    I(face_rect(img_ymin):face_rect(img_ymin)+face_rect(img_height),face_rect(img_xmin):face_rect(img_xmin)+face_rect(img_width),1:end) = blurred; 
end

% show original
figure('Name','After face blur');
imshow(I);

% Task 3: Training our own model with the Viola-Jones object detector

% Load stop signs' model
load('stopSigns.mat');

imDir = fullfile(matlabroot,'toolbox','vision','visiondata','stopSignImages'); 
addpath(imDir);

negativeFolder = fullfile(matlabroot,'toolbox','vision','visiondata','nonStopSigns');
% Train a cascade object detector using HOG features (default):
trainCascadeObjectDetector('stopSignDetector.xml',data,negativeFolder ,'FalseAlarmRate',0.2,'NumCascadeStages',5);
    
detector = vision.CascadeObjectDetector('stopSignDetector.xml');

% Read the test image:
img = imread('stopSignTest.jpg');

%Detect a stop sign:
bbox = step(detector,img);

%Insert bounding boxes and return marked image:
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'stop sign');

% Display the detected stop sign:
figure;
imshow(detectedImg);

% Detect stop sign in lab image
img = imread('Stop_Sign.jpg');

%Detect a stop sign:
bbox = step(detector,img);

%Insert bounding boxes and return marked image:
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'stop sign');

% Display the detected stop sign:
figure;
imshow(detectedImg);

% problem is image is slanted
% Try again

I2 = imrotate(img,20);
img = I2;
bbox = step(detector,img);

%Insert bounding boxes and return marked image:
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'stop sign');

% Display the detected stop sign:
figure;
imshow(detectedImg);

% better but perspective is messing things up - todo, fix!


