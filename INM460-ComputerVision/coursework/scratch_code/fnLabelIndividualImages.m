%fnLabelIndividualImages(searchpath, savepath, manualpath, folders);
%   OCR individual student IDs, move image to labelled folder if possible, 
%   otherwise move to folder for manual OCR.
%   Inputs:
%       searchpath - the path to search
%       savepath - the base path to save to
%       identifiers.
%       manualpath - Location for files that could not be OCRed.
%       folders - the folders to search through
%   Output:
%       none
%   Example:
%   >> searchpath = "../images/";
%   >> savepath = "Processing/"
%   >> manualpath = "IdentifyManually/";
%   >> folders = ["IndividualImages1" "IndividualImages2" "IndividualImages3" "IndividualImages4" "IndividualImages5" "InvididualVideoStills"];
%   >> fnLabelIndividualImages(searchpath, savepath, manualpath, folders);
function fnLabelIndividualImages(searchpath, savepath, manualpath, folders)
    savepath = strcat(searchpath, savepath);
    manualpath = strcat(searchpath, manualpath);
    % create directories
    [status,msg] = mkdir(savepath);
    [status,msg] = mkdir(manualpath);    
    for i=1:length(folders)
        %disp(folders(i))
        % Get a list of all files and folders in this folder.
        path = strcat(searchpath, folders(i));
        files = dir(path);
        for k = 1: length(files)
            if files(k).isdir == 0 % ignore subdirectories
                % debug info
                msg = strcat("Processing image ", folders(i), "/", files(k).name);
                disp(msg);
                % find face and ID
                imgpath = strcat(searchpath, folders(i), "/", files(k).name);
                I = fnSetImageUpright(imgpath);
                % extract digits
                num = '';
                try
                    num = fnGetStudentID(I);
                catch ME
                    msg = strcat("Failed to find ID for ", imgpath);
                    disp(msg)
                end
                % we expect the string to be two characters long, if not, skip
                if length(num) ~= 2 || ~isnumeric(num)
                  msg = strcat("No ID found - ", folders(i), files(k).name);
                  disp(msg);
                  % move to "identify_manually" folder, continue execution of for loop
                  destpath = strcat(manualpath, files(k).name);
                  movefile(imgpath, destpath, 'f')
                  continue
                end
                % Build destination path
                IDPath = strcat(savepath, num);
                % brute force approach, alternatively, check every time for
                % existence of folder, and create if not exists.
                [status,msg] = mkdir(IDPath);
                % move to labelled folder
                movefile(imgpath, IDPath, 'f')
            end
        end
    end
end
