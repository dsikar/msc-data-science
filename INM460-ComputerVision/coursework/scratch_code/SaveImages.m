% STOPPED HERE - NEXT TIME YOU WRITE STOPPED HERE, WRITE TIME AND DATE!!! - NEED TO SORT OUT DIGIT SCAN
% process_images
clear; clc;
% set paths
searchpath = "C:\Users\danielsikar\Documents\GitHub\msc-data-science\INM460-ComputerVision\coursework\images\";
savepath = strcat(searchpath, "Individual\");
% image folders we will loop through
folders = ["IndividualImages1" "IndividualImages2" "IndividualImages3" "IndividualImages4" "IndividualImages5"];
for i=1:length(folders)
    %disp(folders(i))
    % Get a list of all files and folders in this folder.
    path = strcat(searchpath, folders(i));
    files = dir(path);
    % Skip first two hidden directories
    for k = 1 : length(files)
      fname = files(k).name;
      if length(fname) > 8 % omit ., .. and __MACOSX
          msg = strcat("Processing image ", folders(i), "\", files(k).name);
          disp(msg);
          % find face and ID
          imgpath = strcat(searchpath, folders(i), "\", files(k).name);
          I = setupright(imgpath);
          % extract digits
          num = getdigits(I);
          if length(num) ~= 2
              msg = strcat("No ID found - ", folders(i), files(k).name);
              disp(msg);
              continue
          end
          imgcrop = cropface(I);
          % create folder if not exists
          IDpath = strcat(savepath, num);
          [status,msg] = mkdir(IDpath);
          if status == 1 % double check
             msg = strcat("Creating folder ", num); 
          end
          % save cropped image
          ipath = strcat(IDpath, "\", num, "_", files(k).name);
          imwrite(imgcrop, ipath);
          %fprintf('File #%d = %s\n', k, files(k).name);
      end
    end
end
