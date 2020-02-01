% holiday vignette - decrease saturation
% 1 - check centre
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
hold on;
[y,x,z] = size(I);
cx = x/2;
cy = y/2;
plot(cx, cy, 'g+');

% 2 - decrease saturation
clear all;
clc;
I = imread('Instagram.png');
[y,x,z] = size(I);
cx = x/2;
cy = y/2;
HSV = rgb2hsv(I);
H = HSV(:, :, 1);
S = HSV(:, :, 2);
V = HSV(:, :, 3);
s_h = 1; s_s = 1; s_v = 1;
width = x;
height = y;
for x = 1:width
    for y = 1:height
        % Darken image pixels here
        % f = exp(-r/height);
        r = sqrt((cy-y)^2+(cx-x)^2);
        f = exp(-r/y);
        % Think about this function for a second. At the centre of
        % the image, r = 0, and exp(0) = 1. However, as we move away from the centre, the argument
        % to exp is a negative number, producing an f between 0 and 1. When we move far away from
        % the centre, the argument to the exp function is a larger negative number, which produces an
        % f close to zero.        
        % s_h = 1; s_s = r; s_v = 1;
        s_s = 1.5 - f;
        J(y, x, 1) =  s_h * H(y, x);
        J(y, x, 2) =  s_s * S(y, x);
        J(y, x, 3) =  s_v * V(y, x);
    end
end
J = hsv2rgb(J);
figure; imshow(J);
