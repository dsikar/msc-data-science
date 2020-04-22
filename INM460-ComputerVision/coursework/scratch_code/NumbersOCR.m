%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM460 Computer Vision %%
%% Daniel Sikar - PG PT2  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run this script to loop through all group images and classify faces.
% Script will use <TODO what methods>
% Additional options - cartoonify, etc

% capture = imread('IndividualImages1/IMG_2600.JPG'); % sideways - need to
% correct
capture = imread('IndividualImages1/IMG_2594.JPG');
% Increase image size by 3x
% my_image = imresize(capture, 3);
my_image = imrotate(capture,-90,'bilinear');;
figure
imshow(my_image)
% Localize words
BW = imbinarize(rgb2gray(my_image));

% BW1 = imdilate(BW,strel('disk',6));
s = regionprops(BW,'BoundingBox');
bboxes = vertcat(s(:).BoundingBox);
% Sort boxes by image height
[~,ord] = sort(bboxes(:,2));
bboxes = bboxes(ord,:);
% Pre-process image to make letters thicker
BW = imdilate(BW,strel('disk',1));
% Call OCR and pass in location of words. Also, set TextLayout to 'word'
ocrResults = ocr(BW,bboxes,'CharacterSet','.0123456789','TextLayout','word');
words = {ocrResults(:).Text}';
words = deblank(words)
