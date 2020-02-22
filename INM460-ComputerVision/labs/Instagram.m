% Task 4: Instagram
clear;
clc;
% H = imread('northern-lights.jpg');
I = imread('success-Kid.jpg');
% I = imresize(H, 0.25);
imshow(I);

HSV = rgb2hsv(I);
H = HSV(:, :, 1);
S = HSV(:, :, 2);
V = HSV(:, :, 3);

s_h = 1; s_s = 1; s_v = 1;
s_h = 1; s_s = 1; s_v = 1;
J(:, :, 1) = s_h * H;
J(:, :, 2) = s_s * S;
J(:, :, 3) = s_v * V;
J = hsv2rgb(J);
% figure; imshow(J);

hold on;
[y,x,z] = size(I);
cx = x/2;
cy = y/2;
plot(cx, cy, 'g+');

width = x;
height = y;
for x = 1:width
    for y = 1:height
        % Darken image pixels here
        % f = exp(-r/height);
        r = sqrt((cy-y)^2+(cx-x)^2);
        f = exp(-r/y);

        % s_h = 1; s_s = r; s_v = 1;
        s_s = f;
        % J(y, x, 1) =  = s_h * H;
        J(y, x, 2) =  s_s * S(y, x);
        % J(y, x, 3) =  = s_v * V;
    end
end
J = hsv2rgb(J);
figure; imshow(J);