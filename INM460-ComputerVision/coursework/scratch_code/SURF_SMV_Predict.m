%SURF_SMV_Predict(SURFSVMMdl, SURFPointsSave, img)
% Generate a SURF SVM prediction based on feature size used to generate
% model. Assumes grayscale images are used.
% Inputs:
%   SURFSVMMdl - the model
%   SURFPointsSave - feature size used to generate network
%   img - image to predict label of
% Output:
%   label - the predicted image label
% Examples:
% >> SURFSVMMdl = loadCompactModel('SURFSVMMdl.mat')
% >> I = imread('../images/surf_grayscale/02/10d_IMG_2594.JPG');
% >> label = SURF_SMV_Predict(SURFSVMMdl, 30, I);
% >> I = imread('../images/surf_grayscale/23/minus_5d_IMG_6933.JPG');
% label = SURF_SMV_Predict(SURFSVMMdl, 30, I);
%
function label = SURF_SMV_Predict(SURFSVMMdl, SURFPointsSave, I)

    % For compatibility with 
    %I = imread(imgpath);
    % columns we need to keep
    featuresColNo = 64;    
    % detect Speeded-Up Robust Features
    points = detectSURFFeatures(I, 'MetricThreshold', 500, 'NumOctaves', 1 , 'NumScaleLevels', 6);
    % Extract features, do not estimate orientation.
    [featuresOriginal,validPtsOriginal] = extractFeatures(I,points, 'Upright',true);
    %strongPoints = selectStrongest(validPtsOriginal,SURFPointsSave);
    % get the size
    [rows cols] = size(featuresOriginal);
    % save
    f = featuresOriginal(1:rows,:);
    if SURFPointsSave <= rows
        % drop rows/reshape feature vector
        f = f(1:SURFPointsSave,:);
        % flag
        msg = strcat('Index ', string(1), " has ", string(rows), " feature vector rows.");
        disp(msg)
    else
        % pad missing rows with zeros
        padsize = SURFPointsSave - rows;
        f = [f; zeros(padsize,featuresColNo)];
    end
    % f = featuresOriginal(1:SURFPointsSave,:);
    f = f(:);
    label = predict(SURFSVMMdl, f');
end