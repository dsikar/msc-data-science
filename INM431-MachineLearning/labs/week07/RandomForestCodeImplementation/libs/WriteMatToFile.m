function [ status ] = WriteMatToFile( inMat, fileName )
%WriteMatToFile Summary of this function goes here
%   Detailed explanation goes here
%   Writes a Matrix to binary file to be read from a c++ program

fileOut = fopen(fileName,'w+');
fwrite(fileOut, size(inMat), 'double');
fwrite(fileOut, inMat, 'double');

status = fclose(fileOut);
end

