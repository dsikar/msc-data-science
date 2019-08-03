function show_images(Is,num,img_row,img_col)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show num images in Is                                                   %
% sontran2012                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if num>1000, return; end;
if num> size(Is,1), num = size(Is,1); end;
col = floor(sqrt(num));
row = ceil(num/col);
gap = 2;
pos = ones(1,col*row);
pos = cumsum(pos);
pos = reshape(pos,[col row])';

bigImg = zeros(row*img_row + (row-1)*gap,col*img_col + (col-1)*gap);
for i=1:row
    for j=1:col
        y = 1 + (i-1)*(img_row+gap);
        x = 1 + (j-1)*(img_col+gap);
        if pos(i,j) <= num, bigImg(y:y+img_row-1,x:(x+img_col-1)) = reshape(Is(pos(i,j),:),[img_row,img_col])'; end;
    end
end
imshow(bigImg);

end

