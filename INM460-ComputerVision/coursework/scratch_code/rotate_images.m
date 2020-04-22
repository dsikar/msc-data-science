% Crop faces from dataset, rotate left and right, resize to 228x228
% convert to grayscale and save

clear all; clc;
base_dir = '../images/Individual/sorted';
folders = dir(base_dir);
% windows will display '.' and '..' and first two objects in directory,
offset = 2; % avoid . and .. 
folder_number = 1;
%for i=offset+folder_number:offset+folder_number
for i=offset+folder_number:length(folders)
    disp(folders(i).name);
    % files = dir(strcat(base_dir, '/', folders(i).name));
    files = dir(strcat(folders(i).folder, '\', folders(i).name));
    for r=3:length(files)
        disp(files(r).name);
        imgpath = strcat(folders(i).folder, '\', folders(i).name, '\', files(r).name);
        %disp(imgpath);
        % set upright - maybe catch error
        I = setupright(imgpath);
        
        % rotate + 10 degrees
        Ir = imrotate(I,5, 'bilinear');
        % build path
        folderpath = strcat('../images/IndividualGrayscale100x100/', folders(i).name);
        [status,msg] = mkdir(folderpath);
        if status == 1 % double check
            % msg = strcat("Creating folder ", folderpath); 
            disp(msg);
        end
        filename = (strcat(folderpath, '/5d_', files(r).name));
        % crop
        imgcrop = cropface(Ir);        
        % save
        [x,y] = size(imgcrop);
        minsize = 228; % we only want 228x228 minimum
        % store size - the actual storage size
        storesize = 100;
        if x >= minsize
            imgcrop = imresize(imgcrop,[storesize storesize]);
            % convert to greyscale
            imgcrop = rgb2gray(imgcrop);
            imwrite(imgcrop, filename);
        end
        % rotate - 10 degrees
        Ir = imrotate(I,-5, 'bilinear');
        % build path
        filename = (strcat(folderpath, '/minus_5   d_', files(r).name));
        % crop
        imgcrop = cropface(Ir);        
        % save
        [x,y] = size(imgcrop);
        if x >= minsize
            imgcrop = imresize(imgcrop,[storesize storesize]);
            % convert to greyscale
            imgcrop = rgb2gray(imgcrop);            
            imwrite(imgcrop, filename);
        end      
    end
end

