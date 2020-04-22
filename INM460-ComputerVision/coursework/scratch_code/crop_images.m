% Crop faces from dataset, resize to 228x228 and save

clear all; clc;
%crop_images(search_path, save_path, minsize, save_size, gscale)
% base_dir = '../images/Individual/sorted';'
search_path = '../images/sandbox_input/';
save_path = '../images/sandbox_output227x227/';
% convert to grayscale flag
gscale = 0;
% minumum size of face to search
%minwantedsize = 125; 
% storage size
storesize = 227;

% minimum size we are after
minsize = [storesize storesize];

% where to look for our images...

folders = dir(search_path);
% windows will display '.' and '..' and first two objects in directory,
offset = 2; % avoid . and .. 
folder_number = 1;
%for i=offset+folder_number:offset+folder_number
for i=offset+folder_number:length(folders)
    disp(folders(i).name);
    % files = dir(strcat(base_dir, '/', folders(i).name));
    % files = dir(strcat(folders(i).folder, '\', folders(i).name));
    files = dir([search_path folders(i).name])
    for r=3:length(files)
        disp(files(r).name);
        imgpath = strcat(folders(i).folder, '\', folders(i).name, '\', files(r).name);
        %disp(imgpath);
        % set upright - maybe catch error
        I = setupright(imgpath);
        % build path
        folderpath = [save_path folders(i).name];
        [status,msg] = mkdir(folderpath);
        if status == 1 % double check
            % msg = strcat("Creating folder ", folderpath); 
            disp(msg);
        end
        filename = [folderpath, '/', files(r).name];
        % crop
        imgcrop = cropface(I, minsize);        
        % save - trying a different approach, if the face found is smaller,
        % enlarge it to size
        [x,y] = size(imgcrop);
        if x >= 100 % e.g. a side of [100 100]
            % imgcrop = imresize(imgcrop,[minsize minsize]);
            imgcrop = imresize(imgcrop,[storesize storesize]);
            % convert to greyscale
            % No grayscale
            if gscale == 1
                imgcrop = rgb2gray(imgcrop);            
            end
            imwrite(imgcrop, filename);
        end
    end
end

