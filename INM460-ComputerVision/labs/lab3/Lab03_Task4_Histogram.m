%  _____        _     _ _  
% |_   _|_ _ __| |__ | | | 
%   | |/ _` (_-< / / |_  _|
%   |_|\__,_/__/_\_\   |_|                         
%  _  _ _    _                              ___                _ _         _   _          
% | || (_)__| |_ ___  __ _ _ _ __ _ _ __   | __|__ _ _  _ __ _| (_)_____ _| |_(_)___ _ _  
% | __ | (_-<  _/ _ \/ _` | '_/ _` | '  \  | _|/ _` | || / _` | | |_ / _` |  _| / _ \ ' \ 
% |_||_|_/__/\__\___/\__, |_| \__,_|_|_|_| |___\__, |\_,_\__,_|_|_/__\__,_|\__|_\___/_||_|
%                    |___/                        |_|                                     

% The Histogram Equalization algorithm enhances the contrast of images by
% transforming the values in an intensity image so that the histogram of the output
% image is approximately flat.

% housekeeping
clear all;
clc;

I = imread('Hawkes_Bay_NZ.jpg');
figure; imshow(I);
figure; imhist(I, 256);
img_eq = histeq(I); 
figure; imshow(img_eq);
figure; imhist(img_eq, 256);
