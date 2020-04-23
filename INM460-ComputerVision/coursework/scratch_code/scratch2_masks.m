% scratch code mask
clear all;
clc;
% load image

I = imread('facemask-cropped-100px-grayscale.jpg');
% Igs = rgb2gray(I);
% imwrite(Igs, 'facemask-cropped-100px-grayscale.jpg');
figure;
imshow(I);
x = [5 49 96 100 52 3]
y = [20 2 15 54 65 56]
positive_fmask = roipoly(I,x,y);
% convert to integer
% positive_fmask = uint8(positive_fmask);
figure;
imshow(positive_fmask);
negative_mask = ~positive_fmask;
figure;
imshow(negative_mask);
% create 44 row mask
A = ones(34,100);
A = uint8(A);
B = ~A;
% B = uint8(B);
% Apply mask to facemask, observing data types agree
Im = I .* uint8(positive_fmask);
% 100x100 pixel facemask mask
% concatenate rows at start to create full image mask
% note 3 transposes
% TODO - better variable names, please
Bfull = [B' Im']';
imshow(Bfull);
% 100x100pixel student mask
Sfull = [B' positive_fmask']';
% invert as we want to remove facemask area from student face
Sfull = ~ Sfull;
imshow(Sfull);
% apply masks
% Load image
I = imread('../images/surf_grayscale/02/10d_IMG_2594.JPG');
% remove mask section
Im = I .* uint8(Sfull);
% imshow(I .* uint8(Sfull))
% Add mask to student
Im_added_mask = imshow(Im + Bfull);
imshow(Im_added_mask);

