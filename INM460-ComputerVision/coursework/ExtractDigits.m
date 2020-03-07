%FUNCTION_NAME - ExtractDigits 
%
% Syntax:  P = ExtractDigits(I)
%
% Inputs:
%    I - image

% Outputs:
%    P - matrix P with digits in photo
%    P = 
%       0 2
%    P = [] % no digits found

% Example: 
%    P = ExtractDigits('images/Class/IndividualVideos2_stills/IMG_6930_015_crop.JPG')
%
% Author: Daniel Sikar - MSc Data Science - PT2
% SMCSE - City, University of London - daniel.sikar@city.ac.uk
% https://www.github.com/dsikar/inm460-coursework.git

% P = ExtractDigits('images/Class/IndividualVideos2_stills/IMG_6930_015_crop.JPG');

I = imread('images/Class/IndividualVideos2_stills/IMG_6930_015.JPG');
IBoxes = I;
[y, x, z] = size(I);
step = 10;
stepx = x/step; % 
stepy = y/step;
% BFA - Brute Force Approach
margin = 2;
for r = margin:step + margin % to account for overlap
    for k = margin:step + margin
        xmin = r + ((r-1) * stepx*2/3); % overlap by 1/3
        ymin = k + ((k-1) * stepy*2/3);
        bbox = [xmin ymin stepx stepy]; 
        disp(bbox);
        IBoxes = insertObjectAnnotation(IBoxes, 'rectangle', bbox, 'Box');
    end
end
imshow(IBoxes);
    
