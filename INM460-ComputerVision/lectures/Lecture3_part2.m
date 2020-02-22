% Lecture 3

% housekeeping
clear all;
clc;

% original image

I = imread('success-Kid.jpg');
figure('Name','Original');
imshow(I);

% First Derivative Kernels

K = 0.5*[-1 0 1];
Ix = imfilter(I,K);
imshow(Ix,[]);





