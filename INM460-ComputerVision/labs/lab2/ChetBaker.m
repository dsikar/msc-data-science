% load chet baker
% clear all workspaces
clear all;
% clear command window
clc;

I = imread('ChetBaker.png');
imshow(I);
hold on;
% plot(36, 36, 'g+'); %TL
% plot(280, 65, 'g+'); %TR
% plot(280, 290, 'g+'); %BR
% plot(36, 300, 'g+'); % BL
%   430   853

p1 = [36, 36]; p2 = [380, 65]; p3 = [280, 290];
q1 = [1, 1]; q2 = [1, 500]; q3 = [499, 500];
P = [p1; p2; p3];
Q = [q1; q2; q3];
tform = estimateGeometricTransform(P, Q, 'affine');
% Now apply the warp to the image
J = imwarp(I, tform);
figure; imshow(J);

% image k
% 500   499