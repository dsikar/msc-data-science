%fnCropFaces(read_path, write_path)
% Crop faces from images
% Inputs:
%       read_path: the path to read images from
%       write_path: the path to write cropped faces to
% Outputs:
%       cstats: crop processing stats struct
% Example:
% >> read_path = '../images/Processing/';
% >> write_path = '../images/Processed/';
% >> cstats = fnCropFaces(read_path, write_path);
function cstats = fnCropFaces(read_path, write_path)
% ================ Start code ================
    % read folders
    folders = dir(read_path);
    offset = 2; % avoid . and ..   
    for i=1+offset:length(folders)
        % keep track of processing time
        disp(datestr(now,'HH:MM:SS'));
        % Get a list of all files and folders in this folder.
        path = [read_path '/' folders(i).name];
        files = dir(path);
        % create output path
        [status msg] = mkdir([write_path '/' folders(i).name]);
        % keep track of fails
        f = 0;
        for k = 1+offset:length(files)

            % set read path and read image
            imgreadpath = [path '/' files(k).name];
            % debug_msg = ['Cropping ' imgreadpath];
            % disp(debug_msg);                
            I = imread(imgreadpath);
            % crop face
            imgcrop = [];
            FaceDetector = vision.CascadeObjectDetector(); 
            % get bounding boxes
            bbox = step(FaceDetector, I);
            [x,y] = size(bbox);
            if x > 0
                a = bbox(1, 1);
                b = bbox(1, 2);
                c = a+bbox(1, 3);
                d = b+bbox(1, 4);
                imgcrop = I(b:d, a:c, :);
                % set save path and write file to disk
                imgwritepath = [write_path '/' folders(i).name '/' files(k).name];
                imwrite(imgcrop, imgwritepath);                   
            else
                % disp("Could not find face");
                f = f+1;
            end 
        end
        % face cropping stats: folder, total files tf, found tfd, not found tfnd,
        % ratio found rtf, ratio not found rtnf
        tf = (length(files)-2);
        tfd = tf - f;
        tfnd = f;
        rtf = tfd/tf;
        rtnf = tfnd/tf;
        msgstats = [folders(i).name ',' int2str(tf) ',' int2str(tfd) ',' int2str(tfnd) ...
            ',' num2str(rtf) ',' num2str(rtnf)];
        disp(msgstats);
        cstats(i-offset).info = msgstats;
    end 
% ================ End code ================    
end