% Simple crop - practicing for the class photo face blur
% preliminaries, clear workspace
clear all;
clc;

% 1. Read image
a = imread('FaceBlurring.png');

% show original
figure('Name','Original image');
imshow(a);

% pause and close
pause on;
pause(3);
pause off;
close 'Original image';

% indexes
img_xmin = 1;
img_ymin = 2;
img_width = 3;
img_height = 4;

% face rectangle
face_rect = [79, 105, 60, 80];
subImage = imcrop(a, face_rect); % [XMIN YMIN WIDTH HEIGHT]

% "Show crop", i.e. put white rectangle in cropped area
white_rect =  ones(size(subImage))*255;
a(face_rect(img_ymin):face_rect(img_ymin)+face_rect(img_height),face_rect(img_xmin):face_rect(img_xmin)+face_rect(img_width),1:end) = white_rect;
figure('Name','Area to be filtered');
imshow(a);

% pause and close
pause on;
pause(3);
pause off;
close 'Area to be filtered';

% filter/kernel
H = fspecial('disk',10);

% apply filter to cropped image
blurred = imfilter(subImage,H);

% edit in
a(face_rect(img_ymin):face_rect(img_ymin)+face_rect(img_height),face_rect(img_xmin):face_rect(img_xmin)+face_rect(img_width),1:end) = blurred;

% display
figure('Name','Face recognition');
imshow(a);

