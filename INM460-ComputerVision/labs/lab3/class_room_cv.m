I = imread('Class.jpg');
% 
J = imnoise(I,'salt & pepper',0.2);
% filter each channel separately
% Try and experiment with different window sizes.
r = medfilt2(J(:, :, 1),  [3 3]); % [3 3]);
g = medfilt2(J(:, :, 2), [3 3]);
b = medfilt2(J(:, :, 3), [3 3]);
% reconstruct the image from r,g,b channels
K = cat(3, r, g, b);
figure
subplot(121);imshow(J);
subplot(122);imshow(K);
linkaxes;