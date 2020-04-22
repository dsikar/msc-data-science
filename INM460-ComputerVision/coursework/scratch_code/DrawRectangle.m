% insert rectangle

% extract individual student face from image
clear all; clc;
% IM = imread('Student.JPG');
%info = imfinfo('Student.JPG');
% see https://uk.mathworks.com/matlabcentral/answers/260607-how-to-load-a-jpg-properly
% for full rotation implementation - note this rotation will only work for
% this kind of rotated image!!!
% IM = rot90(IM,3);
imgpath = strcat(pwd,'\','Student.JPG');
% correct orientation
I = setupright(imgpath);

FaceDetector = vision.CascadeObjectDetector();
% get bounding boxes
bbox = step(FaceDetector, I);
a = bbox(1, 1);
b = bbox(1, 2);
c = bbox(1, 3);
d = bbox(1, 4);
%c = a+bbox(1, 3);
%d = b+bbox(1, 4);
% add rectangle
I = insertShape(I,'rectangle', [a b c d],'LineWidth',10, ...
    'Color', 'green', 'Opacity',0.7);
% add ID
% known ID
text = cellstr("ID: 01");
% unknown id
text = cellstr("Unknown: 01");
offset = -80;
pos = [(a+offset) (b+offset*2)];
I = insertText(I, pos,text, 'FontSize',98, 'BoxOpacity',0, ...
    'Font', 'Consolas Bold', 'TextColor','green');

imshow(I)