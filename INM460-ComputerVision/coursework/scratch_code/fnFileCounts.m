%function fnFileCounts(dirpath) - print file counts for each subdirectory
% Utility function - show file counts 
% Input: dirpath - directory path
% Output: s - struct with foldernames and counts
%
% Example:
% >> s = fnFileCounts('../images/Processing')
% ans =
%
%     25    91
%     15   115
%     ...
function s = fnFileCounts(dirpath)
    
    folders = dir(dirpath);
    % initialise counts array
    p = [0 0];
    % initialise counts struct
    s(1).ID = '';
    s(1).count = 0;
    offset = 3; % skip hidden sub-directories on windows e.g. "." and ".."
    for i=offset:length(folders)
        % Get a list of all files and folders in this folder.
        path = [dirpath '/' folders(i).name];
        % Populate struct ID
        s(i-offset+1).ID = folders(i).name;
        %files = dir(path);

        c = 0;
        files = dir(path);
        % disp(length(files))
        for k=1:length(files)
            if files(k).isdir == 0
                c = c + 1;
            end
        end
        p(i - offset + 1, :) = [str2num(folders(i).name) c];
        % populated struct count
        s(i-offset+1).count = c;
    end
    % show counts
    sortrows(p,2)    
end