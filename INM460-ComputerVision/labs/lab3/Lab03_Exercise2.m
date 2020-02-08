% INM460 - Computer Vision
%  _         _    ____        ___                _           ___ 
% | |   __ _| |__|__ /  ___  | __|_ _____ _ _ __(_)___ ___  |_  )
% | |__/ _` | '_ \|_ \ |___| | _|\ \ / -_) '_/ _| (_-</ -_)  / / 
% |____\__,_|_.__/___/       |___/_\_\___|_| \__|_/__/\___| /___|
                                                                
% Use peppers image ( I = imread('peppers.png');) and apply Sobel and LOG edge
% detection methods and compare the results.
% (hint: you can use function �edge� to find edges in images and
% imshowpair(BW1,BW2,'montage') to show two images next to each other)

% housekeeping
clear all;
clc;

% First load and convert the image:
img = imread('peppers.png');
imgG = rgb2gray(img);
imgd = im2double(imgG);
I = imgd;

% Sobel Edge detection for vertical edges:
S = [-1, 0, 1 ; -2, 0, 2; -1,0,1];
IS = imfilter(I, S);
%figure; imshow(IS,[]);

% LoG filter:
K = fspecial('log', 11, 1);
J = imfilter(I, K);
%figure; imshow(J,[]);
%title('LoG');

figure;
imshowpair(IS,J,'montage');
title('Sobel and LoG Edge Filters');