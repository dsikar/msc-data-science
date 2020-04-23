% PandemicMode(I)
% Apply facemask (facemask-cropped.jpg) to face, geometry allowing
% Inputs:
%   I - an RGB image containing a face
% Output:
%   Ic - face with facemark
% Example:
% >> I = imread('../images/IndividualCropped/02_IMG_2597.JPG');
% >> img = PandemicMode(I)
%
function If = PandemicMode(I)

    % load RGB facemask image and get size
    Ifm = imread('facemask-cropped.jpg');
    [h w d] = size(Ifm);
    % set return image
    If = I;
    % get size 
    [h1 w1 d1] = size(If);

    % load original facemask masking polygon
    xp = [18 173 330 343 177 4];
    yp = [66 6 55 187 226 194];

    % get ratio r to make facemask image width w 2/3 of face image width w1
    % w*r = (2/3)*w1; r = (2*w1)/(3*w)
    r = (2*w1)/(3*w);
    % resize facemask image
    Ir = imresize(Ifm,r);
    % get new facemask size
    [h2 w2 d2] = size(Ir);

    % resize facemask masking polygon
    xp = round(xp*r);
    yp = round(yp*r);
    % create negative and positive masks
    positive_fmask = roipoly(Ir,xp,yp);
    negative_fmask = ~positive_fmask;
    % create positive facemask image
    Irm = Ir .* uint8(positive_fmask);

    % scheme 1 , based on mouth position
    % locate mouth on face image 
    MouthDetector = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', 16);
    bbox = step(MouthDetector,If); 
    % get mid lowest point coordinates
    xmid = round(bbox(1,1) + bbox(1,3) / 2);
    ylow = bbox(1,2) + bbox(1,4);
    % define top left coordinates for facemask mask, based on mid lowest point
    yhigh = ylow - h2;
    xhigh = round(xmid - w2/2);
    % scheme 2 , based on image ratio, set lowest point 1/10 from bottom,
    % mid point middle of image
    yhigh = round(h1*0.9) - h2;
    xhigh = round(h1/2 - w2/2);

    % crop section off face
    imgcrop = If(yhigh:yhigh+h2-1,xhigh:xhigh+w2-1,:);
    % Apply negative facemask (remove facemark geometry)
    imgcrop = imgcrop .* uint8(negative_fmask);
    % Add positive facemask image
    imgcrop = imgcrop + Irm;
    % Graft back into face
    If(yhigh:yhigh+h2-1,xhigh:xhigh+w2-1,:) = imgcrop;

end