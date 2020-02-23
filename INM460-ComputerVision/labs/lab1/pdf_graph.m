% pdf - probability density function
I = imread('cars.png');
figure; imshow(I);
figure; imhist(I, 256); % calculates the histogram for the grayscale image I
h = imhist(I, 256);
[rows, cols] = size(I);
% Intensity ranges from 0 to 255. Since Matlab array indices start at 1, we
% use 256 bins. In addition to displaying the histogram, we want to display
% a probability distribution, where the area under the curve will be equal
% to 1. To do so, we need to divide each bucket value by the number of
% pixels in the image.
pdf = h / (rows*cols);
figure;
plot(pdf);
title('pdf of image intensities');
xlabel('intensity');
ylabel('probability');

RGB = imread('peppers.png');
imshow(RGB)
I = rgb2gray(RGB);
figure; imhist(I, 256);
h = imhist(I, 256);
[rows, cols] = size(I);
pdf = h / (rows*cols);
figure;
plot(pdf);
title('pdf of image intensities');
xlabel('intensity');
ylabel('probability');