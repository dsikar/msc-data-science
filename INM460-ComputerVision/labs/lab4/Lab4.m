% Lab 4
% Task 1: Finding starfish
clear all;
clc;

% 1. Read image
a = imread('OnTheBeach.png');

% show original
figure('Name','OnTheBeach.png');
imshow(a);

% Task 1a: Blur
h = fspecial('disk',1.5);
%hsize = 10;
%sigma = 10;
%h = fspecial('gaussian',hsize,sigma)
% apply filter and save image
blurred = imfilter(a,h);
% display
figure('Name','OnTheBeach.png blurred');
imshow(blurred);

% Task 1b: Colour segmentation
% RGB 219 117 43
offset = 30;
Rmin = 219 - offset;
Rmax = 219 + offset;
Gmin = 117 - offset;
Gmax = 117 + offset;
Bmin = 43 - offset;
Bmax = 43 + offset;

% make a copy
blurred_copy = blurred;
% Binary values
% RED
blurred_copy(:,:,1) = ~(blurred_copy(:,:,1) < Rmin | blurred_copy(:,:,1) > Rmax);
% set 1 to 255
R = blurred_copy(:,:,1)
R(R==1) = 255;
blurred_copy(:,:,1) = R;
% GREEN
blurred_copy(:,:,2) = ~(blurred_copy(:,:,2) < Gmin | blurred_copy(:,:,2) > Gmax);
G = blurred_copy(:,:,2);
G(G==1) = 255;
blurred_copy(:,:,2) = G;
% BLUE
blurred_copy(:,:,3) = ~(blurred_copy(:,:,3) < Bmin | blurred_copy(:,:,3) > Bmax);
B = blurred_copy(:,:,3);
B(B==1) = 255;
blurred_copy(:,:,3) = B;

% Binary
figure('Name','OnTheBeach.png binary');
imshow(blurred_copy);

blurred_copy(:,:,1) == 255 & blurred_copy(:,:,2) == 255 & blurred_copy(:,:,3) == 255