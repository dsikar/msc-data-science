%SURF_SMV_Predict(HOGSVMMdl, cellsize, img)
% Generate a HOG SVM prediction based hog cell size used to generate
% model. Assumes grayscale images are used.
% Inputs:
%   HOGSVMMdl - the classifier model
%   cellsize - h x w array size of a HOG cell in pixels
%
%   Note, *cellsize* is used to generate HOG SVM classifier models and the
%   same cellsize must be used for model predictions, i.e. if [10 10] cellsize
%   was used to generate model, the same size should be used for
%   predictions. See "help HOG_SVM_prototype_featuresOriginal" for more
%   information.
%
%   img - grayscale face image to predict label of
% Output:
%   label - the predicted face image label
% Examples:
% >> HOGSVMMdl = loadCompactModel('HOGSVMMdl.mat')
% >> I = imread('../images/surf_grayscale/02/10d_IMG_2594.JPG');
% >> label = HOG_SMV_Predict(HOGSVMMdl, [10 10], I);
% >> I = imread('../images/surf_grayscale/23/minus_5d_IMG_6933.JPG');
% label = HOG_SMV_Predict(HOGSVMMdl, [10 10], I);
%
function label = HOG_SMV_Predict(HOGSVMMdl, cellsize, I)

    % For compatibility with RecogniseFace, image is used, not image path, 
    % as cropped face images will be passed to function
    %I = imread(imgpath);
    % extract HOG features
    [hog1,visualization] = extractHOGFeatures(I,'CellSize',cellsize);
    label = predict(HOGSVMMdl, hog1);
end