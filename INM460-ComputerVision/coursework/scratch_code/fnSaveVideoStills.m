% fnSaveVideoStills(baseVidPath, folder_sfx, savepath)
% Save stills from video files
%   Inputs:
%       baseVidPath - folders containing videos to process
%       folder_sfx - suffixes of folders containing videos
%       savepath - path to save still images to
%   Output:
%       none
%   Examples:
%   >> baseVidPath = '../images/IndividualVideos';
%   >> folder_sfx = ["1" "2" "3"];
%   >> savepath = '../images/InvididualVideoStills/';
%   >> fnSaveVideoStills(baseVidPath, folder_sfx, savepath);
% Run once to process videos, saving frames as individual images
function fnSaveVideoStills(baseVidPath, folder_sfx, savepath)
    [status msg] = mkdir(savepath);
    for j=1:length(folder_sfx)
        vidPath = strcat(baseVidPath, folder_sfx(j), '/');
        % loop through all videos
        files = dir(vidPath);
        for i=1:length(files)
            % skip directories
            if files(i).isdir == 0
                filepath = strcat(vidPath, files(i).name);
                disp(filepath);
                % Save still images
                % SaveVideoStills(vidPath, files(i).name, int2str(i));
                % read video
                readPath = strcat(vidPath, files(i).name);
                vid=VideoReader(readPath);
                numFrames = vid.NumberOfFrames;
                n=numFrames;
                % offset to avoid dark/blurred images
                offset = 3;
                % get frames and save as individual images
                for k = 1 + offset:n - offset
                    frames = read(vid,k);
                    writePath = strcat(savepath, '/', int2str(i), '_', int2str(k), '.JPG');
                    imwrite(frames,writePath);
                end 
            end
        end
    end
end
    