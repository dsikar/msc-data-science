% Task 3: Sharpening
K = [0, -1, 0; -1, 5, -1; 0, -1, 0];
img = imread('Westminster.jpg');
imgG = rgb2gray(img);
imgd = im2double(imgG);
img1 = imfilter(imgd,K);
subplot(121);imshow(imgG);
subplot(122);imshow(img1);
linkaxes;

% Task 4: Histogram Equalization 

img = imread('Hawkes_Bay_NZ.jpg');
figure, img_eq = histeq(img); imshow(img_eq);

% Task 5: Edge Detection

% First load and convert the image:

img = imread('Westminster.jpg');
imgG = rgb2gray(img);
imgd = im2double(imgG);
I = imgd;

% Vertical Edges:

K = 0.5*[-1 0 1];
Ix = imfilter(I, K);
figure;
imshow(Ix,[]); % show full dynamic range with [] 

% Horizontal Edges:

K = 0.5*[-1 0 1]';
Iy = imfilter(I, K);
figure;
imshow(Iy,[]);

% Sobel Edge detection for vertical edges:

S = [-1, 0, 1 ; -2, 0, 2; -1,0,1];
IS = imfilter(I, S);

% LoG filter:

K = fspecial('log', 11, 1);
J = imfilter(I, K);
figure; imshow(J,[]);
title('LoG');

figure; imshow(IS,[]);

% peppers

I = imread('peppers.png');

% Sobel Edge detection for vertical edges:
S = [-1, 0, 1 ; -2, 0, 2; -1,0,1];
IS = imfilter(I, S);

% LoG filter:

K = fspecial('log', 11, 1);
J = imfilter(I, K);
figure; % imshow(J,[]);
% title('LoG');

imshowpair(IS,J,'montage')