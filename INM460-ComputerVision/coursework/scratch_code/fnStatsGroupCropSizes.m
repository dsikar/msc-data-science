%fnStatsGroupCropSizes(read_path, write_path)
% Display statistics on image sizes
% Inputs:
%       read_path: the path to read images from
% Outputs:
%       cstats: Image statistics
% Example:
% >> read_path = '../images/Processed/';
% >> cstats = fnStatsGroupCropSizes(read_path);
function cstats = fnStatsGroupCropSizes(read_path)
% ================ Start code ================
    % init struct
    % cstats = [];
    % read folders
    folders = dir(read_path);
    offset = 2; % avoid . and .. 
    % image counter
    imgcnt = 1;
    for i=1+offset:length(folders)
        % keep track of processing time
        %disp(folders(i).name);
        %disp(datestr(now,'HH:MM:SS'));
        % Get a list of all files and folders in this folder.
        path = [read_path '/' folders(i).name];
        files = dir(path);
        % create student stats array
        st = zeros(length(files)-offset,1);
        for k = 1+offset:length(files)
            % set read path and read image
            imgreadpath = [path '/' files(k).name];             
            I = imread(imgreadpath);
            
            % crop faces % as per RecogniseFace
            minsize = [85 85];    
            FaceDetector = vision.CascadeObjectDetector('MinSize', minsize);
            % get bounding boxes
            bbox = step(FaceDetector, I);
            [rows,cols] = size(bbox(:,:));
            % initialise return array

            st = zeros(rows,1);
            for j = 1:rows
                % 1. draw rectangles
                a = bbox(j, 1);
                b = bbox(j, 2);
                c = bbox(j, 3);
                d = bbox(j, 4);

                % Crop
                c2 = a+c;
                d2 = b+d;
                imgcrop = I(b:d2, a:c2, :); 
                s = size(imgcrop);
                st(j)=s(1);
                
            end
            % assign result to struct
            cstats(imgcnt).ID = files(k).name;
            cstats(imgcnt).sizes = st;
            % Display stats
            mn = min(cstats(imgcnt).sizes);
            mx = max(cstats(imgcnt).sizes);
            md = mode(cstats(imgcnt).sizes);
            mdn = median(cstats(imgcnt).sizes);
            msg = ['Image crop size stats for ' cstats(imgcnt).ID ', min: ' num2str(mn) ', max: ' ...
                num2str(mx) ', median: ' num2str(mdn) ', mode: ' num2str(md)];
            disp(msg);  
            imgcnt = imgcnt + 1;
        end

    end 
    
    % display overall averages
    [j c] = size(cstats)
    oa = zeros(c,4);
    try
        for j=1:c
            oa(j,1) = min(cstats(j).sizes);
            oa(j,2) = max(cstats(j).sizes);
            oa(j,3) = mode(cstats(j).sizes);
            oa(j,4) = median(cstats(j).sizes);  
        end  

        mn   = round(sum(oa(:,1))/c);
        mx   = round(sum(oa(:,2))/c);
        md   = round(sum(oa(:,3))/c);
        mdn   = round(sum(oa(:,4))/c);
        msg = ['Image size average stats (rounded) , avgmin: ' num2str(mn) ', avgmax: ' ...
            num2str(mx) ', avgmedian: ' num2str(mdn) ', avgmode: ' num2str(md)];
        disp(msg);  
    catch ME
        disp(j);
    end
% ================ End code ================    
end