function [ outMat ] = ReadMatFromFile( fileName )
%ReadMatFromFile Summary of this function goes here
%   Detailed explanation goes here
% Reads a Matrix from a binary file generated from opencv c++ program
outMat = [];
fileIn = fopen(fileName, 'r');
rows = fread(fileIn, 1, 'double');
cols = fread(fileIn, 1, 'double');

outMat = fread(fileIn,[rows,cols], 'double');
fclose(fileIn);
end

