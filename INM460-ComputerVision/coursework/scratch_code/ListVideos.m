
    %%%%%%%%%%%%%%%%%%%%%%%
    %% SAVE VIDEO STILLS %%
    %%%%%%%%%%%%%%%%%%%%%%%

% Tidy up environment
clc;
clear all;
close all;
tic;
  
% Path
folder_idx = '3'; % int2str(idx)
vidPath = ['../images/IndividualVideos' folder_idx '/'];
% loop through all videos
files = dir(vidPath);
for i=1:length(files)
	if files(i).isdir == 0
        filepath = [vidPath files(i).name];
        disp(filepath);
        % Save still images
        SaveVideoStills(vidPath, files(i).name, int2str(i));
    end
end
    