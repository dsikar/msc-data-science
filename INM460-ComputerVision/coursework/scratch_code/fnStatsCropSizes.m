%fnStatsCropSizes(read_path, write_path)
% Display statistics on image sizes
% Inputs:
%       read_path: the path to read images from
% Outputs:
%       cstats: Image statistics
% Example:
% >> read_path = '../images/Processed/';
% >> cstats = fnStatsCropSizes(read_path);
function cstats = fnStatsCropSizes(read_path)
% ================ Start code ================
    % init struct
    % cstats = [];
    % read folders
    folders = dir(read_path);
    offset = 2; % avoid . and ..   
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
            s = size(I);
            st(k-offset)=s(1);
        end
        % assign result to struct
        cstats(i-offset).ID = folders(i).name;
        cstats(i-offset).sizes = st;
        % Display stats
        mn = min(cstats(i-offset).sizes);
        mx = max(cstats(i-offset).sizes);
        md = mode(cstats(i-offset).sizes);
        mdn = median(cstats(i-offset).sizes);
        msg = ['Image size stats for ' cstats(i-offset).ID ', min: ' num2str(mn) ', max: ' ...
            num2str(mx) ', median: ' num2str(mdn) ', mode: ' num2str(md)];
        disp(msg);        
    end 
    % display overall averages
    [j c] = size(cstats)
    oa = zeros(c,4);
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
% ================ End code ================    
end