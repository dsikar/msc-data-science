% add stuff to face
imgpath = 'C:\Users\danielsikar\Documents\GitHub\msc-data-science\INM460-ComputerVision\coursework\images\Individual\sorted\78\IMG_6995.JPG';

I = setupright(imgpath);

% imshow(setupright(imgpath))
minsize = [400 400];
% defaults to ClassificationModel 'FrontalFaceCART'
FaceDetector = vision.CascadeObjectDetector('MinSize', minsize);

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

imshow(I);

Iface = cropface(I);
minsize = [50 50];
FaceDetector = vision.CascadeObjectDetector('ClassificationModel', 'Nose','MinSize', minsize);

bbox = step(FaceDetector, Iface);
a = bbox(1, 1);
b = bbox(1, 2);
c = bbox(1, 3);
d = bbox(1, 4);
%c = a+bbox(1, 3);
%d = b+bbox(1, 4);
% add rectangle
Iface = insertShape(Iface,'rectangle', [a b c d],'LineWidth',10, ...
    'Color', 'green', 'Opacity',0.7);

imshow(Iface);
