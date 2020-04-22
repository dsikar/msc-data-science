imgpath = "C:\Users\danielsikar\Documents\GitHub\msc-data-science\INM460-ComputerVision\coursework\images\IndividualImages1\IMG_2597.JPG"
capture = setupright(imgpath);
% Increase image size by 3x
% my_image = imresize(capture, 3);
my_image = capture;
figure
imshow(my_image)
% Localize words
BW = imbinarize(rgb2gray(my_image));
BW1 = imdilate(BW,strel('disk',6));
s = regionprops(BW1,'BoundingBox');
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