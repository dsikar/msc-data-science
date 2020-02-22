% Lecture 3

% housekeeping
clear all;
clc;

% original image

I = imread('success-Kid.jpg');
figure('Name','Original');
imshow(I);

% Identity kernel

K = [
    [0,0,0];
    [0,1,0];
    [0,0,0]
    ];
      
J = imfilter(I,K);
figure('Name','Identity Filter');
imshow(J);

% Moving average

% Convert to double

% if converting to double...
I = double(imread('Success-Kid.jpg'));

K = ones(3,3)*1/9;

% ...we need to normalize K
J = imfilter(I,K/255);
figure('Name','Moving average or box filter');
imshow(J);

% Gaussian Filter
I = imread('success-Kid.jpg');

K = fspecial('gaussian', 5, 1); % 5x5, sigma (standard deviation) = 1
% imgaussfilt directly performs Gaussian filtering
J = imfilter(I,K);
figure('Name','Gaussian filter');
imshow(J);

% Sharpening Filter

% A sharpening filter makes edges more pronounced
% Built-in Matlab function: imsharpen

K = ones(3,3) * (-1/9);
K(2,2) = 17/9;

J = imfilter(I,K);
figure('Name','Sharpening filter');
imshow(J);

% Non-linear filtering

% Median filter

I = imread('Westminster.jpg');
J = imnoise(I,'salt & pepper',0.2);
% filter each channel separately
r = medfilt2(J(:, :, 1), [3 3]);
g = medfilt2(J(:, :, 2), [3 3]);
b = medfilt2(J(:, :, 3), [3 3]);
% reconstruct the image from r,g,b channels
K = cat(3, r, g, b);

% filter each channel separately
r = medfilt2(J(:, :, 1), [3 3]);
g = medfilt2(J(:, :, 2), [3 3]);
b = medfilt2(J(:, :, 3), [3 3]);
% reconstruct the image from r,g,b channels
K = cat(3, r, g, b);
figure
subplot(121);imshow(J);
subplot(122);imshow(K);
linkaxes;

% and once again for a second clean-up
% filter each channel separately
r = medfilt2(K(:, :, 1), [3 3]);
g = medfilt2(K(:, :, 2), [3 3]);
b = medfilt2(K(:, :, 3), [3 3]);
% reconstruct the image from r,g,b channels
K = cat(3, r, g, b);
figure
subplot(121);imshow(J);
subplot(122);imshow(K);
linkaxes;






