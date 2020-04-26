read_path = '../images/extract/in/';
write_path = '../images/extract/out/';
cstats = fnCropFaces(read_path, write_path);
[e c] = size(cstats);
for i=1:c
    disp(cstats(i).info);
end
