function s_m = discrete2softmax(inp,nmax)
% Convert discrete data into softmax
sNum = size(inp,1);
s_m = zeros(sNum,nmax);
s_m([1:sNum] + (inp'-1)*sNum) = 1;
end

