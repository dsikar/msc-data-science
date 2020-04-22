% Coursework, scratch code

% Identify faces in photo and output

% 1. Open image

% code for Prerna:

% load image
I = imread('Class.jpg');
K = fspecial('disk', 20);
R = imfilter(I,K,'replicate');
% detect faces
FaceDetector = vision.CascadeObjectDetector();
% get bounding boxes
bbox = step(FaceDetector, I);
% get bounding box count
N = size(bbox, 1);
% loop trough all boxes
for i=1:N
    % Extract ith face
    a = bbox(i, 1);
    b = bbox(i, 2);
    c = a+bbox(i, 3);D
    d = b+bbox(i, 4);
    % Overwrite I
    I(b:d, a:c, :) = R(b:d, a:c, :);
end
imshow(I);