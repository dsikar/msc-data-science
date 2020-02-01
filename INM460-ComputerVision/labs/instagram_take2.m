% Transformation in HSV space
% This can be done in other colour spaces too.
% Example: decreasing saturation
clear all;
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

% holiday - increase saturation
clear all;
clc;
I = imread('Instagram.png');
HSV = rgb2hsv(I);
H = HSV(:, :, 1);
S = HSV(:, :, 2);
V = HSV(:, :, 3);
s_h = 1; s_s = 1.5; s_v = 1;
J(:, :, 1) = s_h * H;
J(:, :, 2) = s_s * S;
J(:, :, 3) = s_v * V;
J = hsv2rgb(J);
figure; imshow(J);

