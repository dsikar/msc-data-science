%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM460 Computer Vision %%
%% Daniel Sikar - PG PT2  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% From https://uk.mathworks.com/help/vision/examples/recognize-text-using-optical-character-recognition-ocr.html

clear;
clc;
% Run this script to loop through all group images and classify faces.
% Script will use <TODO what methods>
% Additional options - cartoonify, etc

% capture = imread('IndividualImages1/IMG_2600.JPG'); % sideways - need to
% correct
I = imread('IndividualImages1/IMG_2594.JPG');
% I = imread('IndividualImages1/IMG_2602.JPG');
% I = imread('IndividualImages1/two.png');
% I = imread('IndividualImages1/eight.png');

I = imrotate(I,-90,'bilinear');

% I = imresize(I, 3);

figure
imshow(I)
% Localize words
% BW1 = imbinarize(rgb2gray(my_image));

% Remove keypad background.
%Icorrected = imtophat(I,strel('disk',15));

% BW1 = imbinarize(Icorrected);
BW1 = imbinarize(rgb2gray(I));
% Text = ocr(BW1, 'CharacterSet','0123456789','TextLayout','Block')

% TODO - approach hereafter
% 1. Define a frame size
% 2. Sweep image with overlapping vertical and horizontal frame positions
% 3. Store characters and confidences for every frame
% 4. Sort by highest confidence pair and label image
% alternatively,
% 2. Locate blue frame for number
% 3. Sweep image near blue frame
% repeat steps 3 and 4 from first approach

figure; 
imshowpair(I,BW1,'montage');


% Perform morphological reconstruction and show binarized image.
% marker = imerode(Icorrected, strel('line',10,0));
marker = imerode(~BW1, strel('line',10,0));
Iclean = imreconstruct(marker, ~BW1);

BW2 = imbinarize(Iclean);

position = [1263 2049 400 400];
Idigits = insertObjectAnnotation(I,'rectangle',position,'found');
J = imcrop(I,position);
J = imbinarize(rgb2gray(J));
results = ocr(J, 'CharacterSet','0123456789','TextLayout','Block');
% size = 4
% CharacterConfidences for first 2 charaters = high > .87
% CharacterConfidence for last 2 characters = NaN
% Build expression
% ~isnan(str2double(results.Text(4))) ~isnan(str2double(results.Text(4))) ~isnan(str2double(results.Text(4))) ~isnan(str2double(results.Text(4)))
% see confidence intervals
figure; 
imshowpair(Iclean,BW2,'montage');

results = ocr(BW2,'TextLayout','Block');

results.Text

% The regular expression, '\d', matches the location of any digit in the
% recognized text and ignores all non-digit characters.
regularExpr = '\d';

% Get bounding boxes around text that matches the regular expression
bboxes = locateText(results,regularExpr,'UseRegexp',true);

digits = regexp(results.Text,regularExpr,'match');

% draw boxes around the digits
Idigits = insertObjectAnnotation(I,'rectangle',bboxes,digits);

figure; 
imshow(Idigits);

% Use the 'CharacterSet' parameter to constrain OCR
results = ocr(BW2, 'CharacterSet','0123456789','TextLayout','Block');

results.Text

% Sort the character confidences.
[sortedConf, sortedIndex] = sort(results.CharacterConfidences, 'descend');

% Keep indices associated with non-NaN confidences values.
indexesNaNsRemoved = sortedIndex( ~isnan(sortedConf) );

% Get the top ten indexes.
topTenIndexes = indexesNaNsRemoved(1:10);

% Select the top ten results.
digits = num2cell(results.Text(topTenIndexes));
bboxes = results.CharacterBoundingBoxes(topTenIndexes, :);

Idigits = insertObjectAnnotation(I,'rectangle',bboxes,digits);

figure; 
imshow(Idigits);
