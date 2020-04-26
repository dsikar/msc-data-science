%RecogniseFace - Recognise face based on feature and classifier type (H1 line)
%
% Syntax:  P = RecogniseFace(I, featureType, classifierType, creativeMode)
%
% Inputs:
%    I - image path 
%    featureType - SURF, HOG
%    classifierType - SVM, MLP, CNN
%       Implemented featureType/ClassifierType:
%       'SURF', 'HOG'
%       'SURF', 'SVM'
%       '', 'CNN'
%    creativeMode - boolean flag, if set face image is modified creatively
% Outputs:
%    P - matrix P describing the student(s) present in an RGB image I. 
%    P is a matrix of size N x 3, where N is the number of people detected 
%    in the image. Example, if the function detects two students in the 
%    image, with student with ID=03 having his/her face centred at position 
%    [144, 153], and student with ID=13 at position [312,123], the P matrix 
%    would be
%    P =
%       03 144 153
%       13 312 123
%
% Example: 
%    SURF, HOG, no creative mode
%    P = RecogniseFace('Class5.jpg', 'SURF', 'SVM', 0)
%    P = RecogniseFace('class.jpg', 'HOG', 'SVM', 0)
%    CNN, creative mode
%    P = RecogniseFace('class.png', '', 'CNN', 1)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2
% Author: Daniel Sikar - MSc Data Science - PT2
% SMSE - City, University of London - daniel.sikar@city.ac.uk
% https://www.github.com/dsikar/inm460-coursework.git
function P = RecogniseFace(I, featureType, classifierType, creativeMode)
    % Coding guidelines
    % http://www.datatool.com/downloads/matlab_style_guidelines.pdf
    
%------------- BEGIN CODE --------------
    
    % Validation
    % 1. Image
    try
        I = fnSetImageUpright(I); 
    catch
        error('Invalid filepath or file. See ''help RecogniseFace''.');
        return;
    end   
    % 2. Classifier and feature types validation
    % SURF-SVM, HOG-SVM or CNN
    if ~( (strcmp(featureType,'SURF') & strcmp(classifierType,'SVM') ) ...
      |   ( strcmp(featureType,'HOG') & strcmp(classifierType,'SVM') ) ...
      |   ( strcmp(featureType,'') & strcmp(classifierType, 'CNN') ) )
  
        error('Invalid feature-classifier. See ''help RecogniseFace''.');
        return;
        
    end;

    % load classifier
    if classifierType == "CNN"
        load('dan_net4');
    elseif classifierType == "SURF"
        SURFPointsSave = 30;
        SURFSVMMdl = loadCompactModel('SURFSVMMdl.mat');
    elseif classifierType == "HOG"
        cellsize = [10 10];
        HOGSVMMdl = loadCompactModel('HOGSVMMdl.mat');            
    end

    % minimum expected face size in photo
    minsize = [85 85];    
    FaceDetector = vision.CascadeObjectDetector('MinSize', minsize);
    % get bounding boxes
    bbox = step(FaceDetector, I);
    [rows,cols] = size(bbox(:,:));
    % initialise return array
    P = [];
    
    for i = 1:rows
        % 1. draw rectangles
        a = bbox(i, 1);
        b = bbox(i, 2);
        c = bbox(i, 3);
        d = bbox(i, 4);

        % Crop
        c2 = a+c;
        d2 = b+d;
        imgcrop = I(b:d2, a:c2, :);
        % scale
        % skip for now
        % Convert to grayscale and resize, as per training/testing dataset
        % imgcrop = rgb2gray(imgcrop);
        % The size used to train our classifiers and neural network
        side = 227;
        imgcropclass = imresize(imgcrop,[side side]);  
        if classifierType == "CNN"
            % predict
            [myclass, err] = classify(dan_net4,imgcropclass);
            % get confidence
            conf = max(err);
        elseif classifierType == "SURF"
            % TODO CONVERT TO GRAYSCALE
            myclass = SURF_SMV_Predict(SURFSVMMdl, SURFPointsSave, imgcropclass);;
        elseif classifierType == "HOG"
            % TODO CONVERT TO GRAYSCALE
            myclass = HOG_SMV_Predict(HOGSVMMdl, cellsize, imgcropclass);            
        end
        
        % Creative mode
        if creativeMode == 1
            try
                img = PandemicMode(imgcrop);
                % todo remove, just for the publicity shot
                if i ~= 20
                    I(b:d2, a:c2, :) = img;
                end
            catch ME
                warning('Could not supply facemask for this image');
            end 
        end
        % TODO comment back in
        %I = insertShape(I,'rectangle', [a b c d],'LineWidth',10, ...
        %    'Color', 'green', 'Opacity',0.7);
        % set ID as not found
        ID = '-1';
        conf_thresh = 0.50;
        % debug flag
        debug = 1;
        % todo - sort out IDlabel handling for SURF and HOG
        IDlabel = ID;
        if conf >= conf_thresh 
            ID = string(myclass);
            if debug == 1
                IDlabel = strcat(string(i), ': ', ID);
            else
                IDlabel = ID;
            end
            %v = str2num(ID);
        end
        % ID print offset
        offset = -40; % pixels
        pos = [(a+offset) (b+offset*2)];
        % Removed for publicity shot
        %I = insertText(I, pos,cellstr(IDlabel), 'FontSize',60, 'BoxOpacity',0, ...
        %    'Font', 'Consolas Bold', 'TextColor','green');
        % debug info
        msg = strcat('ID: ', string(ID), ', image: ', string(i), ', conf: ', ... 
            string(conf), ', size: ', string(c), 'x', string(d));
        disp(msg);
        
    end    
   
    figure; imshow(I);   

%------------- END OF CODE --------------

end