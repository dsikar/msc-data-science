% Images in Matlab - from Lecture 2
clear all;
clc;
I = imread('peppers.png');
imshow(I); % class(I) 'uint8'
% imshow(I(:, :, 1)); % all rows, all columns, red channel
J = double(I);

% uint8 and double
% Images are typically uint8 when loaded. However, sometimes it may be
% convenient to convert them to double (e.g. for filtering). Matlab supports type
% conversions:
I = imread('peppers.png');
J = double(I);

% Conversions to greyscale
I = imread('Holiday.png');
imshow(I);
I1 = rgb2gray(I);
imshow(I1);

% Other colour space conversions
I = imread('Holiday.png');
imshow(I);
J = rgb2hsv(I);
imshow(J(:,:,1)); % H
figure;
imshow(J(:,:,2)); % S
figure;
imshow(J(:,:,3)); % V
% and back with hsv2rgb
K = hsv2rgb(J);