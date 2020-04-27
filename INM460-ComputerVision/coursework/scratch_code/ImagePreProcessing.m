% ImagePreProcessing.m
% All pre-processing, to generate data for training and testing classifier models
clear all;
clc;

% 1. Extract stills from videos
disp("Extracting stills from videos...");

baseVidPath = '../images/IndividualVideos';
folder_sfx = ["1" "2" "3"];
savepath = '../images/InvididualVideoStills/';
% fnSaveVideoStills(baseVidPath, folder_sfx, savepath);

% 2. Label individual images automatically (with digit extration)
disp("Labelling stills automatically...");

searchpath = "../images/";
savepath = "Processing/"
manualpath = "IdentifyManually/";
folders = ["IndividualImages1" "IndividualImages2" "IndividualImages3" "IndividualImages4" "IndividualImages5" "InvididualVideoStills"];
%fnLabelIndividualImages(searchpath, savepath, manualpath, folders);

% 3. Label images manually
disp("Labelling stills manually, press RETURN in Command Window when complete...");
pause;

% 4. Augmentation
disp("Augmentation, blurring images...");
% 4.1 Blur images
% fnBlurImages('../images/Processing/', 0.5, [1 2 3 4 5 6 7 8 9 10])

% 4.2 Rotate images
disp("Augmentation, rotating images...");
% fnRotateImages('../images/Processing/', 0.7, [-10 -8 -6 -4 -2 2 4 6 8 10])

% 5. Crop faces and display stats
read_path = '../images/Processing/';
write_path = '../images/Processed/';
cstats = fnCropFaces(read_path, write_path);
for i=1:c
    disp(cstats(i).info);
end

% 6. Manually remove misclassified faces then display counts to determine 
%    number of images that will be used
disp("Remove misclassified faces manually, press RETURN in Command Window when complete...");
pause;

s = fnFileCounts('../images/Processed')