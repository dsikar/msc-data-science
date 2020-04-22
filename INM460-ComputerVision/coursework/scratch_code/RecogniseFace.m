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
%    creativeMode - 0,1,2,3,4,5,6,7
%    0 - No special effect
%    1 - Cartonize
%    2 - Dark glasses
%    3 - Long beard
%    4 - Short beard
%    5 - Lipstick
%    6 - Moustache
%    7 - Scarface
%    8 - Eyebags
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
%    SURF, HOG, no special effects
%    P = RecogniseFace('Class5.jpg', 'SURF', 'SVM', [0])
%    SURF, SVM, cartonize
%    P = RecogniseFace('class.jpg', 'HOG', 'SVM', [1])
%    CNN, lipstick, moustache, scarface, eyebags
%    P = RecogniseFace('class.png', '', 'CNN', [5,6,7,8])
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
    
    % NB - Set path to script path 

    % Validation
    % 1. Image
    try
        I = setupright(I); 
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
    % Load model - TODO add others
    load('dan_net4');
    %img = imread('../images/IndividualGrayscale/06/minus_10d_IMG_2620.JPG');
    %[class, err] = classify(dan_net1,img);
    %disp(class);
    %disp(max(err));
    
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
        side = 227;
        imgcrop = imresize(imgcrop,[side side]);  
        % predict
        [myclass, err] = classify(dan_net4,imgcrop);
        % get confidence
        conf = max(err);
        
        I = insertShape(I,'rectangle', [a b c d],'LineWidth',10, ...
            'Color', 'green', 'Opacity',0.7);
        % set ID as not found
        ID = '-1';
        conf_thresh = 0.50;
        % debug flag
        debug = 1;
        if conf >= conf_thresh 
            ID = string(myclass);
            if debug == 1
                IDlabel = strcat(string(i), ': ', ID);
            else
                IDlabel(ID);
            end
            %v = str2num(ID);
        end
        % ID print offset
        offset = -40; % pixels
        pos = [(a+offset) (b+offset*2)];
        I = insertText(I, pos,cellstr(IDlabel), 'FontSize',60, 'BoxOpacity',0, ...
            'Font', 'Consolas Bold', 'TextColor','green');
        % debug info
        msg = strcat('ID: ', string(ID), ', image: ', string(i), ', conf: ', ... 
            string(conf), ', size: ', string(c), 'x', string(d));
        disp(msg);
        
        % TODO caricature
        a = round(a + c/2);
        b = round(b + d/2);
        ID = round(str2double(ID));
        P(i,:) = [ID, a, b];
    end    
   
    figure; imshow(I);   

%------------- END OF CODE --------------

end