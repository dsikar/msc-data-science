% scratch code mask
clear all;
clc;
% load RGB facemask image and get size
Ifm = imread('facemask-cropped.jpg');
[h w d] = size(Ifm);
% load original facemask masking polygon
xp = [18 173 330 343 177 4]
yp = [66 6 55 187 226 194]
% load face image
%If = imread('../images/IndividualCropped/01_IMG_6862.JPG');
If = imread('../images/IndividualCropped/02_IMG_2597.JPG');
% get size 
[h1 w1 d1] = size(If);
% get ratio r to make mask image 2/3 of face image
% x*r/x1 = 2/3; r = (2x1)/(3x)
r = (2*w1)/(3*w);
% resize image
Ir = imresize(Ifm,r);
% get new facemask size
[h2 w2 d2] = size(Ir);

% resize facemask masking polygon
xp = round(xp*r);
yp = round(yp*r);
% create negative and positive masks
positive_fmask = roipoly(Ir,xp,yp);
negative_fmask = ~positive_fmask;
% create masked facemask image
Irm = Ir .* uint8(positive_fmask);

% locate mouth on face image 
MouthDetector = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', 16);
bbox = step(MouthDetector,If); 
% get mid lowest point coordinates
xmid = round(bbox(1,1) + bbox(1,3) / 2);
ylow = bbox(1,2) + bbox(1,4);
% define the top left coordinates for facemask mask, based on this point
yhigh = ylow - h2;
xhigh = round(xmid - w2/2);
% TODO add matlab error trapping to deal with out of bound errors - blame
% on mask shortage
% crop section off image
imgcrop = If(yhigh:yhigh+h2-1,xhigh:xhigh+w2-1,:);
% Apply mask
imgcrop = imgcrop .* uint8(negative_fmask);
% Add facemask
imgcrop = imgcrop + Irm;
% Graft back into image
If(yhigh:yhigh+h2-1,xhigh:xhigh+w2-1,:) = imgcrop;
figure;
imshow(If)

% calculate left side padding for new facemask, number of columns to add
p = round((w1 - w2) / 2);
% create padding matrix 
pm = zeros(h2, p, 3);
% concatenate left hand size
Irp = [pm Ir];
% pad end ~ width minus reduced mask size plus left padding
p2 = w1 - (w2 + p);
% create padding matrix 
pm = zeros(h2, p2, 3);
% concatenate right hand side
Irpp = [Irp pm];
% resize polygon
xr = round(xp*r);
yr = round(yp*r);
% adjust facemask masking polygon 
xp = xp + p;
% create positive mask to include facemask image

% create negative mask to exclude facemask image

% todo locate nose

% add padding above and below facemask

% superimpose images

% alt approach
% apply all changes to reduced mask, graft resulting matrix in bigger
% matrix





positive_fmask = roipoly(Ifm,x,y);
% convert to integer
% positive_fmask = uint8(positive_fmask);
figure;
imshow(positive_fmask);
negative_mask = ~positive_fmask;
figure;
imshow(negative_mask);
% create 44 row mask
A = ones(34,100);
A = uint8(A);
B = ~A;
% B = uint8(B);
% Apply mask to facemask, observing data types agree
Ifm = Ifm .* uint8(positive_fmask);
% 100x100 pixel facemask mask
% concatenate rows at start to create full image mask
% note 3 transposes
% TODO - better variable names, please
Bfull = [B' Ifm']';
imshow(Bfull);
% 100x100pixel student mask
Sfull = [B' positive_fmask']';
% invert as we want to remove facemask area from student face
Sfull = ~ Sfull;
imshow(Sfull);
% apply masks
% Load image
Ifm = imread('../images/surf_grayscale/02/10d_IMG_2594.JPG');
% remove mask section
Ifm = Ifm .* uint8(Sfull);
% imshow(I .* uint8(Sfull))
% Add mask to student
Im_added_mask = imshow(Ifm + Bfull);
imshow(Im_added_mask);

