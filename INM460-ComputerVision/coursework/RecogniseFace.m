%FUNCTION_NAME - One line description of what the function or script performs (H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
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
%    P is amatrix of size N x 3, where N is the number of people detected 
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
%    P = RecogniseFace('class.png, 'SURF', 'HOG', [0])
%    SURF, SVM, cartonize
%    P = RecogniseFace('class.png, 'SURF', 'SVM', [1])
%    CNN, lipstick, moustache, scarface, eyebags
%    P = RecogniseFace('class.png, '', 'CNN', [5,6,7,8])
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
    % Clear environment and command window
    % Bad move, this clears parameters!!!
    % clear all;
    % clc;
    
    % Set path to script path - No need for this if no "clear"
    %mypath = matlab.desktop.editor.getActiveFilename;
    %mypath = reverse(mypath);
    %idx = strfind(mypath,'\');
   % mypath = reverse(extractBetween(mypath,idx(1),idx(end)));
    %cd(string(mypath));
    % Validation
    % 1. Image
    try
        a = imread(I);
        
    catch
        disp(I);
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
    %strValidate = 1; % 0. false, invalid entry
    %if(strValidate == 1)
    %    help RecogniseFace;
    %    return;
    %end
    
    % carry on
    P = [03 144 153;13 312 123];

%------------- END OF CODE --------------

end