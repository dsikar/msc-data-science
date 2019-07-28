function s_m = discrete2softmax(inp,nmax)
% Convert discrete data into one-hot (softmax) encoding.
%
%   Input
%   -----
%   inp : vector
%     A column vector containing integers corresponding to discrete categories.
%     
%   nmax : integer
%     Maximum number of categories.
%
%   Output
%   ------
%   s_m : matrix
%     Matrix containing one-hot (softmax) encodings of the discrete values in 
%     inp. Each row corresponds to a single value in the inp vector.

sNum = size(inp,1);
s_m = zeros(sNum,nmax);
s_m([1:sNum] + (inp'-1)*sNum) = 1;
end

