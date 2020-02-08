% INM460 - Computer Vision
%  _         _      ____        ___                _           _ 
% | |   __ _| |__  |__ /  ___  | __|_ _____ _ _ __(_)___ ___  / |
% | |__/ _` | '_ \  |_ \ |___| | _|\ \ / -_) '_/ _| (_-</ -_) | |
% |____\__,_|_.__/ |___/       |___/_\_\___|_| \__|_/__/\___| |_|

% Exercise 1: Load one of your images (or use ‘class.jpg’ provided on Moodle) and
% blur only the faces. The result should look like the image below.
% Hint: you can manually find the coordinates of the faces and apply the filter to it
% and put it back in the big image.

% clear workspace and command window
clear all;
clc;

% indexes
img_xmin = 1;
img_ymin = 2;
img_width = 3;
img_height = 4;

% Read the image
I = imread('Class.jpg');

% show original
figure('Name','Before face blur');
imshow(I);

% pause and close
pause on;
pause(3);
pause off;
close 'Before face blur';

% all face coordinates
faces = [   [372, 814, 70, 100]; % [XMIN YMIN WIDTH HEIGHT] % BACK ROW
            [810, 874, 70, 100];
            [1240, 920, 70, 100];
            [1551, 937, 70, 100];            
            [1766, 923, 70, 100];             
            [2062, 941, 70, 100];           
            [2292, 948, 70, 100];              
            [2451, 959, 70, 100];        
            [2738, 974, 70, 100];
            [2962, 970, 70, 100];
            [3102, 978, 70, 100];
            [3298, 986, 70, 100];
            % 2nd from last row
            [454, 926, 70, 100];
            [1066, 986, 70, 100];
            [1502, 986, 70, 100];
            [2006, 1054, 70, 100];
            [2282, 1050, 70, 100];
            [2594, 1062, 70, 100];
            % middle row
            [194, 1142, 100, 150];
            [494, 1162, 100, 150];
            [998, 1130, 100, 150];
            [1566, 1202, 100, 150];
            [2234, 1182, 70, 100];
            [2522, 1190, 70, 100]
            % 2nd row from front
            [390, 1430, 150, 250]; 
            [1482, 1382, 120, 200];
            [2118, 1394, 100, 150];
            [2582, 1430, 100, 150];
            [3094, 1402, 100, 150];
            % front row
            [1301, 2206, 190, 250];            
            [2026, 2034, 190, 250];
            [2678, 1970, 190, 250];
            [3678, 1970, 190, 250]
];
[rows, cols] = size(faces);
% loop through all image coordinates
for j=1:rows
    face_rect=faces(j,:);
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

