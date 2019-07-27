function visualize_1l_filters(filters,num,row,col,normalize)
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

