% From slides:
% The command to load an image is imread
% To show an image, use the command imshow
clear all;
clc;
I = imread('greens.jpg');
imshow(I);
% Check I in the Workspace:
disp(size(I)); % 300   500     3 - NB Matlab uses height x width
disp(class(I)); % uint8 - 8 bit precision integers
% red channel
imshow(I(:, :, 1));
% green channel
imshow(I(:, :, 2));
% blue channel
imshow(I(:, :, 3));
% converting to double - convenient for filtering
I = imread('greens.jpg');
J = double(I);
class(J); % double
% However to visualise, need to divide by 255
imshow(J/255);
% Alternatively
J = im2double(I);
imshow(J);
% Converting to grayscale
I1 = rgb2gray(I);
imshow(I1);
% Additional slides covered in lab

