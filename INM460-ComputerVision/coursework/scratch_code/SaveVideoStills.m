% SaveVideoStills - Save video stills to path (H1 line)
%
% Syntax:  SaveVideoStills(vidPath, filename)
%
% Inputs:
%    vidPath - path of video file 
%    filename - name of video file
%    idx - video file folder index
% Outputs:
%    None
%
% Example: 
%    SaveVideoStills('../images/IndividualVideos1/', 'IMG_6907.mp4', idx) 
function SaveVideoStills(vidPath, filename, idx)

    vid=VideoReader([vidPath filename]);
    numFrames = vid.NumberOfFrames;
    n=numFrames;
    % dark/blurred end allowance
    offset = 3;
    for i = 1 + offset:n - offset
        frames = read(vid,i);
        imwrite(frames,[vidPath 'IndividualStills/sort/' idx '_' int2str(i) '.JPG']);
    end 
end
    