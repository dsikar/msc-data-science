% This is not doing well do to photos being taken from the side
% With frontal photos, and certain lighting conditions, it is possible 
% to segment the sign, and provided the photo is not taken from the side,
% i.e. lines are not slanted, digit can be recognised. Otherwise digit
% cannot be recognise and it turns into a manual labelling job.

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
clear all; clc;
imgpath = "C:\Users\danielsikar\Documents\GitHub\msc-data-science\INM460-ComputerVision\coursework\images\IndividualImages1\IMG_2594.JPG";
I = setupright(imgpath);
IBoxes = I;
[y, x, z] = size(I);
margin = 100; % pixels
boxwidth = 400; % 
xsteps = round((x - boxwidth) / margin); % e.g. (3000 - 400) / 100 = 26 x steps
ysteps = round((y - boxwidth) / margin);
% BFA - Brute Force Approach
offsetx = 5;
offsety = 20;
for x = offsetx:xsteps % to account for overlap x - increments of 100
    for y = offsety:ysteps 
        xpos = x * margin;
        ypos = y * margin;
        bbox = [xpos ypos boxwidth boxwidth]; 
        imcrop = I(ypos:ypos+boxwidth,xpos:xpos+boxwidth,:);
        
        digit = rgb2gray(imcrop);
        imshow(digit);
        
        ID = ocr(digit,'CharacterSet','.0123456789');
        chars = deblank(ID.Text);
        if ~isnan(str2double(chars))
            msg = strcat("Found ID: ", chars);
            disp(msg)
        end
        IBoxes = insertObjectAnnotation(IBoxes, 'rectangle', bbox, 'Box');
    end
end
imshow(IBoxes);
    
