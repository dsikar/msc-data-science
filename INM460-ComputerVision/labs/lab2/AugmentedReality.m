% Task 5: Augmented reality with a projective transformation
% clear all workspaces
clear all;
% clear command window
clc;
% Images
I = imread('AlbumReview.bmp');
imshow(I);
hold on;
% plot(36, 36, 'g+'); %TL
% plot(280, 65, 'g+'); %TR
% plot(280, 290, 'g+'); %BR
% plot(36, 300, 'g+'); % BL
%   430   853

%Image matching
%Built-in Matlab function: estimateGeometricTransform
% Estimate affine transformation through correspondences
%I = imread('LicensePlate.png');
p1 = [18, 47]; p2 = [15, 100]; p3 = [178, 6];
q1 = [48, 50]; q2 = [48, 100]; q3 = [212, 50];
P = [p1; p2; p3];
Q = [q1; q2; q3];
tform = estimateGeometricTransform(P, Q, 'affine');
% Now apply the warp to the image
J = imwarp(I, tform);
figure; imshow(J);

% image k
% 500   499
