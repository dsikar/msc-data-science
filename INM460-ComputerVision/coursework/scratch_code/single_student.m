% extract individual student face from image
clear all; clc;
imgpath = "C:\Users\danielsikar\Documents\GitHub\msc-data-science\INM460-ComputerVision\coursework\images\IndividualImages1\IMG_2597.JPG"
%debug IndividualImages1\IMG_2595.JPG
% correct orientation
IM = setupright(imgpath);
% extract digits
% What about turning image to black and white?

%I=imread(imgpath);
I = setupright("14Slanted.jpg");
figure; imshow(I);

% Rotate clockwise 15 degrees to align base
J1 = imrotate(I, -20, 'bilinear');
figure; imshow(J1);
% Now apply a skew
tform = affine2d([1 .3 0; 0 1 0; 0 0 1]');
J2 = imwarp(J1, tform);
figure; imshow(J2);


% imshow(I);
I = rgb2gray(J2);
ID = ocr(I,'CharacterSet','.0123456789');

chars = ID.Text;

imshow(IM);
num = getdigits(IM);
% detect face
FaceDetector = vision.CascadeObjectDetector();
% get bounding boxes
bbox = step(FaceDetector, IM);
a = bbox(1, 1);
b = bbox(1, 2);
c = a+bbox(1, 3);
d = b+bbox(1, 4);
% scale image if required
imshow(IM(b:d, a:c, :));
% save image

