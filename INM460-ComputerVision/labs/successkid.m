% success kid
clear;
clc;
I = imread('success-Kid.jpg');
HSV = rgb2hsv(I);
H = HSV(:, :, 1);
S = HSV(:, :, 2);
V = HSV(:, :, 3);
s_h = 1; s_s = 0.5; s_v = 1;
J(:, :, 1) = s_h * H;
J(:, :, 2) = s_s * S;
J(:, :, 3) = s_v * V;
J = hsv2rgb(J);
figure; imshow(J);