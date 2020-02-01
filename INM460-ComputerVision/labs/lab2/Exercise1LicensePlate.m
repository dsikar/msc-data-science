% Exercise 1
% Test: manually transform image in order to have well-aligned digits
I = imread('LicensePlate.png');
figure; imshow(I);
% Rotate clockwise 15 degrees to align base
J1 = imrotate(I, -15, 'bilinear');
figure; imshow(J1);
% Now apply a skew
tform = affine2d([1 .3 0; 0 1 0; 0 0 1]');
J2 = imwarp(J1, tform);
figure; imshow(J2);