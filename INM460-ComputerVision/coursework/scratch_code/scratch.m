%read_path = '../images/Class/stills/';
%cstats = fnStatsGroupCropSizes(read_path);
%imagesizes = [227 128 70];
%chromascheme = ["rgb" "grayscale"];
%for k=1:length(chromascheme)
%    for j=1:length(imagesizes)
%        strdir = strcat(chromascheme(k), '/', num2str(imagesizes(j)), '/');
%        disp(strdir);
%    end
%end
%offset = 2;
%searchpath = "../images/sandbox_output/";
%folders = dir(searchpath);
% total samples
%ts = length(folders)-offset;
% folder (label) samples
%fd = randsample(linspace(offset+1,ts+offset,ts), 8)

searchpath = "../images/sandbox_output/";
savepath = "../images/model/samples/";
samplelabelsize = 8;
samplefilesize = 50;
imagesizes = [227 128 70];
chromascheme = ["rgb" "grayscale"];
fnGetSampleImages(searchpath, savepath, samplelabelsize, samplefilesize, imagesizes, chromascheme);
