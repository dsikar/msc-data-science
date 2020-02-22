% Task 1: Smoothing
clear all;
clc;

% img = londonEye;
img = imread('LondonEye.jpg');
imgG = rgb2gray(img);
imgd = im2double(imgG); % imgd in [0,1]
% f = ones(3,3)/9;
% f = ones(3,3)/18; % darker
% f = ones(3,3)/4; % lighter
% different sizes
% f = ones(6,6)/9; % whiteout
f = ones(3,3)/9; % whiteout

img1 = imfilter(imgd,f);
%figure;
%subplot(121); imshow(imgd);
%subplot(122); imshow(img1);
%linkaxes;

img = imread('cameraman.tif');
imgd = im2double(img); % imgd in [0,1]
imgd = imnoise(imgd,'salt & pepper',0.02);
f = ones(3,3)/9;
img1 = imfilter(imgd,f);
subplot(121);imshow(imgd);
subplot(122);imshow(img1);
linkaxes;

% How about trying the Matlab's built-in median filter?
I = imread('cameraman.tif');
J = imnoise(I,'salt & pepper',0.02);
K = medfilt2(J);
% class(K) 'uint8'
% size(K) 256   256

subplot(121);imshow(J);
subplot(122);imshow(K);
linkaxes;

I = imread('cameraman.tif');
radius = 1;
J1 = fspecial('disk', radius);
K1 = imfilter(I,J1,'replicate');
radius = 10;
J10 = fspecial('disk', radius);
K10 = imfilter(I,J10,'replicate');
subplot(131);imshow(I);title('original');
subplot(132);imshow(K1);title('disk: radius=1');
subplot(133);imshow(K10);title('disk: radius=10');
linkaxes;

I = imread('Westminster.jpg');
% 
J = imnoise(I,'salt & pepper',0.2);
% filter each channel separately
% Try and experiment with different window sizes.
r = medfilt2(J(:, :, 1),  [6 6]); % [3 3]);
g = medfilt2(J(:, :, 2), [6 6]);
b = medfilt2(J(:, :, 3), [6 6]);
% reconstruct the image from r,g,b channels
K = cat(3, r, g, b);
figure
subplot(121);imshow(J);
subplot(122);imshow(K);
linkaxes;