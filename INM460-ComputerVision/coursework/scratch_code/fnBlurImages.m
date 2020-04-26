%fnBlurImages(read_path, ratio, radius)
% Blur ramdom numfiles images in read_path by blur factor and save to same
% path
% Input:
%   read_path: the path to read from
%   ratio: the ratio of files to blur
%   radius: blur values to choose from
% Output:
%   none
% Example:
% >> fnBlurImages('../images/Processing/', 0.5, [1 2 3 4 5 6 7 8 9 10])
function fnBlurImages(read_path, ratio, radius)
    % read folders
    folders = dir(read_path);
    offset = 2; % avoid . and ..    
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
                % pick random value from blur
                b = randsample(radius, 1); 
                h = fspecial('disk',b);
                Ib=imfilter(I,h);
                % set save path
                imgpath = [path '/blur_' int2str(b) '_' files(k).name];
                % save file
                imwrite(Ib, imgpath);     
           end
        end
    end
end
    

