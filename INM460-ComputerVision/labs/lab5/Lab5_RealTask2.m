% Task 2: Tracking through segmentation
% 1. Face detection -  cascade object detector Viola Jones - cropping
% 2. Grayscale
% 3. Resizing
% 4. Balancing 

% For MLP and SVM - grayscale
% CNN - RGB

% Augmentation + video -> need to create a lot more images, for training
% phase (we will not show all images of one individual (hold out, etc).


% augmentation (larger and smaller)
videoReader = VideoReader('GregPen.avi');
images = read(videoReader);

% This will store the video frames in a 4D array called images. The ith frame can be read as
% I = images(:,:,:,i);

I = images(:,:,:,1);
figure;
imshow(I)

% R 195 260, G 37 93, B 125 190