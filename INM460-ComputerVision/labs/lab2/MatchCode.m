% Test: match code to transformed image
clear all;
clc;

I = imread('Holiday.png');
R = imref2d([700,700]);
% Transformation 1 - move along y axis, no distortion
A = affine2d([.5 0 0; 0 .5 100; 0 0 1]'); 
[J, RJ] = imwarp(I, A, 'OutputView', R);
imshow(J, RJ);

% Transformation 4 - move along y axis, y distortion
A = affine2d([0 .5 0; .5 .5 100; 0 0 1]');
[J, RJ] = imwarp(I, A, 'OutputView', R);
imshow(J, RJ);

% Transformation 3 - move along x axis, x distortion
A = affine2d([.5 .5 100; 0 .5 0; 0 0 1]');
[J, RJ] = imwarp(I, A, 'OutputView', R);
imshow(J, RJ);

% Transformation 2 - move along x axis, no distortion
A = affine2d([.5 0 100; 0 .5 0; 0 0 1]');
[J, RJ] = imwarp(I, A, 'OutputView', R);
imshow(J, RJ);