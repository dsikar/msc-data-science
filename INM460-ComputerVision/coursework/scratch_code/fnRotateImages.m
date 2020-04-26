%fnRotateImages(read_path, ratio, rotation) 
% Rotate ramdom ratio images in read_path by rotation degrees and save
% Input:
%   read_path: the path to read files from
%   numfiles: a random number of files to rotate
%   rotation: the quantity in degrees to rotate by
% Output:
%   none
% Example:
% fnRotateImages('../images/Processing/', 0.7, [-10 -8 -6 -4 -2 2 4 6 8 10])
function fnRotateImages(read_path, ratio, rotation)
    % read folders
    folders = dir(read_path);
    offset = 2; % avoid . and .. 
    file_number = 1;    
    for i=1+offset:length(folders)
        %disp(folders(i))
        % Get a list of all files and folders in this folder.
        path = [read_path folders(i).name];
        files = dir(path);
        % set a sequence and sample
        x = size(files);
        x = x(1) - offset;
        s = linspace(offset+1,x+offset,x);  
        s = randsample(s,round(x*ratio));
        for k = 1+offset:length(files)
           if sum(ismember(s,k)) == 1
                % set read path
                imgpath = [path '/' files(k).name];
                debug_msg = ['Processing ' imgpath];
                disp(debug_msg);                
                % set upright 
                I = fnSetImageUpright(imgpath);
                % pick random value from rotation
                b = randsample(rotation, 1); 
                % rotate
                Ir = imrotate(I, b, 'bilinear');
                % set save path
                %imgpath = [path '/blur_' int2str(b) '_' files(k).name];
                imgpath = [path '/rot' int2str(b) 'd_' files(k).name];
                % save file
                imwrite(Ir, imgpath);     
           end
        end
    end
end
    

