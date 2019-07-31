function visualize_1l_filters(filters,num,row,col,normalize)
% Visualise one neural network hidden layer (filters).
%
%   Input
%   -----
%   filters : matrix
%     Weight matrix (the filter which is applied to data)
%   num : integer
%     Number of filters to visualise
%   row : integer
%     Number of rows of each filter
%   col : integer
%     Number of columns of each filter
%   normalize : string
%     Type of normalization to apply while filtering

%Visualize filter
filters = filters';
if strcmp(normalize,'minmax')
   MN = min(min(filters));
   MX = max(max(filters));
   filters = (filters-MN)/(MX-MN);
elseif strcmp(normalize,'sigmoid')
   filters = logistic(filters)
end
show_images(filters,min(num,size(filters,1)),row,col);
end

