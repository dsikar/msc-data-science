%fnBlurImages(read_path, write_path, numfiles, rotation)
% Blur ramdom numfiles images in read_path by blur factor and save to write_path
% Input:
%   read_path: the path to read files from
%   write_path: the path to write rotated files to
%   numfiles: a random number of files to blur
%   rotation: the quantity to blur by
% Output:
%   none
% Example:
% fnBlurImages('../images/sandbox_input/25', ...
% '../images/sandbox_aug/25_aug', 100, 2)
function fnBlurImages(read_path, write_path, numfiles, blur)
    % read files
    files = dir(read_path);
    % create destination folder
    mkdir(write_path);
    % get number of files
    x = size(files);
    % windows os will display '.' and '..' as first two objects in directory,
    offset = 2; % avoid . and .. 
    file_number = 1;
    % set the sequence we will sample from
    s = linspace(offset+file_number,x(1),x(1)-offset);
    % sample
    s = randsample(s,numfiles);
    % for i=offset+folder_number:offset+folder_number
    % s = randsample(n,k)
    % sum(ismember(x,5))
    for i=offset+file_number:length(files)
        % if file is in list of random files, process and save
        if sum(ismember(s,i)) == 1
            % set read path
            imgpath = [read_path '/' files(i).name];
            % set upright
            I = setupright(imgpath);
            % blur
            h = fspecial('disk',blur);
            Ib=imfilter(I,h);
            % set save path
            imgpath = [write_path '/blur_' int2str(blur) 'd_' files(i).name];
            % save file
            imwrite(Ib, imgpath);
        end
    end
end
    

