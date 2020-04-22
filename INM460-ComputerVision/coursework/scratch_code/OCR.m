% TODO - turn into function

% extract digit characters from image
clear all; clc;
imgpath = strcat(pwd,'\','Student.JPG');
I = setupright(imgpath);
% imshow(I);
% segmentation from lab 5 solution
J = I(:,:,1)>212 ...
& I(:,:,2)>215 ...
& I(:,:,3)>221;
% Keep largest component
K = bwareafilt(logical(J),1);
% Compute centroid c
c = regionprops(logical(K), 'Centroid');
% get polygon around area
m = 300;
a = c.Centroid(1) - m;
b = c.Centroid(2) - m;
c = a + m * 2;
d = b + m * 2;
digit = I(b:d, a:c, :);
% turn to grayscale
% digit = rgb2gray(digit);
imshow(digit);
% ocr - from lab 
ID = ocr(digit,'CharacterSet','.0123456789');
chars = ID.Text;
% str = convertCharsToStrings(chars)
% do not convert to grayscale, test for size
% remove trailing null character
% strcat("_", deblank(str))
