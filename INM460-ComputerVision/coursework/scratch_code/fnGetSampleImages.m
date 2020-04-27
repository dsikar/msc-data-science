%fnGetSampleImages(searchpath, savepath, samplelabelsize, samplefilesize, imagesizes, chromascheme);
%   Create a working sample of images
%   Inputs:
%       searchpath - the path to search
%       savepath - the base path to save to
%       samplelabelsize - the number of labels required, if 0, use all
%       samplefilesize - the sample size
%       imagesizes - the image sizes, one directory will be created for
%       every size.
%       chromascheme - which colour scheme to use
%   Output:
%       none
%   Example:
%   >> searchpath = "../images/Processed/";
%   >> savepath = "../images/Processed/samples/";
%   >> samplelabelsize = 8;
%   >> samplefilesize = 50;
%   >> imagesizes = [227 128 70];
%   >> chromascheme = ["rgb" "grayscale"]
%   >> fnGetSampleImages(searchpath, savepath, samplelabelsize, samplefilesize, imagesizes, chromascheme);
function fnGetSampleImages(searchpath, savepath, samplelabelsize, samplefilesize, imagesizes, chromascheme)
    % create sample directories
    for k=1:length(chromascheme)
        for j=1:length(imagesizes)
            strdir = strcat(savepath, '/', chromascheme(k), '/', num2str(imagesizes(j)), '/');
            [status msg] = mkdir(strdir);
        end
    end
    % ignore hidden directories offset
    offset = 2;
    folders = dir(searchpath);
    % total samples
    ts = length(folders)-offset;
    % folder (label) samples
    fd = randsample(linspace(offset+1,ts+offset,ts), samplelabelsize);    
    for i=offset+1:length(folders)
        %disp(folders(i))
        % Is this one of the random sample folders?
        if sum(ismember(fd, i)) == 1       
            % Get a list of all files and folders in this folder.
            fpath = strcat(searchpath, folders(i).name);
            files = dir(fpath);
            % total samples
            tfs = length(files)-offset;
            % file samples
            fld = randsample(linspace(offset+1,tfs+offset,tfs), samplefilesize);                
            % select
            for k = offset+1:length(files)
                % Is this one of the random sample files?
                if sum(ismember(fld, k)) == 1 
                    % Set path
                    imgpath = strcat(searchpath, folders(i).name, "/", files(k).name);
                    I = imread(imgpath);
                    % debug info
                    % msg = strcat("Processing image ", imgpath);
                    % disp(msg);  
                    % save required formats
                    for r=1:length(chromascheme)
                        for j=1:length(imagesizes)
                            % fresh image copy to alter
                            Ic = I;                            
                            if chromascheme(r) == "grayscale"
                                Ic = rgb2gray(Ic);
                            end
                            % resize
                            Ic = imresize(Ic, [imagesizes(j) imagesizes(j)]);
                            % create directory
                            strsavedir = strcat(savepath, '/', chromascheme(r), '/', num2str(imagesizes(j)), ...
                                '/', folders(i).name);
                            [status msg] = mkdir(strsavedir);
                            % set image name
                             strsavedir = strcat(savepath, '/', chromascheme(r), '/', num2str(imagesizes(j)), ...
                                '/', folders(i).name, '/', files(k).name);  
                            % save
                            imwrite(Ic,strsavedir);
                        end
                    end
                end
            end
        end
    end
end
