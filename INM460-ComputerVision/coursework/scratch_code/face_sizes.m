% scan folders and list file sizes and dimensions:
% Having examined file sizes, we'll set file size to 228 x 228 for our CNN
clear all; clc;
%base_dir = '../images/IndividualCropped';
base_dir = '../images/IndividualRotated';
files = dir(base_dir);
% keep track of the smallest image
minsize = 1000;
for i=1:length(files)
    if files(i).isdir == 0
        %disp(files(i).name);
        filepath = strcat(base_dir, "/", files(i).name);
        I = imread(filepath);
        [x,y,z] = size(I);
        if x < minsize
            minsize = x;
            disp(files(i).name);
        end
    end
end
disp(minsize);

% From IndividualCropped
%02_IMG_2599.JPG
%   260

% From IndividualRotated
% 01_10d_IMG_6862.JPG
%   423