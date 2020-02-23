% pdf - probability density function
I = imread('cars.png');
figure; imshow(I);
figure; imhist(I, 256);
h = imhist(I, 256);
[rows, cols] = size(I);
pdf = h / (rows*cols);
figure;
plot(pdf);
title('pdf of image intensities');
xlabel('intensity');
ylabel('probability');