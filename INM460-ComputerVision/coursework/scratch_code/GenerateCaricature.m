% GenerateCaricature(I, mode, minsize)
% Generate a caricature for faces present in image
% Inputs:
%   I - an image containing faces
%   mode - array of caricature features to apply
%   minsize - expected minimum size of face in pixels
% Output:
%   Ic - image with caricature applied to faces
% Examples:
% >> I = imread('../images/surf_grayscale/02/10d_IMG_2594.JPG');
% >> img = GenerateCaricature(I, ['pandemic'], [85 85])
%
function IC = GenerateCaricature(I, mode, minsize)
    % locate mouth  
    MouthDetector = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', 16);
    bbox = step(MouthDetector,I);    
    
    figure,
    imshow(I); hold on
    for i = 1:size(bbox,1)
        rectangle('Position',bbox(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
    end
    % imgcaric = '';
end