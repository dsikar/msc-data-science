% INM460 Lab - week 2 - Task 3
% Method 1
I = imread('peppers.png');
imshow(I);
% negative
J = 255 - I;
figure; imshow(J);
% Method 2
% An image is a collection of pixels (for a colour image, each having a red, green, and blue
% component). The pixels are in the form of a 2D grid. If you wish, you can loop over all these
% pixels, using a doubly-nested loop (loop within a loop), i.e.,
I = imread('peppers.png');
[height, width, channels] = size(I);
for x = 1:width
    for y = 1:height
        J(y, x, 1) = 255 - I(y, x, 1); % invert red
        J(y, x, 2) = 255 - I(y, x, 2); % invert green
        J(y, x, 3) = 255 - I(y, x, 3); % invert blue
    end
end
% Note that because the matrix indices are given as rows, then columns, the y comes before
% the x when indexing pixels from the image.
figure; imshow(J);

% Method 3
% In this example, we’ll still use a doubly-nested loop to loop over all the pixels in the image.
% Since inverting an image applies the same operation to the red, green, and blue colours, we
% can use the colon operator to access the third dimension in the image (the colour at this
% pixel) and process the colour with a single line of code.
I = imread('peppers.png');
[height, width, channels] = size(I);
for x = 1:width
    for y = 1:height
        J(y, x, :) = 255 - I(y, x, :); % invert red, green, and blue
    end
end
figure; imshow(J);
%Instead of inverting colours, try to write a script that swaps colours between different colour
%channels, for example, swapping red for blue. You may find it’s easier to complete this task
%using the Method 2 code above. Can you reproduce the image below? Suddenly those
%peppers look less tasty!
I = imread('peppers.png');
[height, width, channels] = size(I);
for x = 1:width
    for y = 1:height
        % swapping red for blue
        % J(y, x, 1) = 255 - I(y, x, 1); % invert red
        J(y, x, 1) = I(y, x, 3); % invert red
        J(y, x, 2) = I(y, x, 2); % invert green
        % J(y, x, 3) = 255 - I(y, x, 3); % invert blue
        J(y, x, 3) = I(y, x, 1); % invert blue
    end
end
% show
figure; imshow(J);

for x = 1:width
    for y = 1:height
        % swapping green and blue
        % J(y, x, 1) = 255 - I(y, x, 1); % invert red
        J(y, x, 1) = I(y, x, 1); % invert red
        J(y, x, 2) = I(y, x, 3); % invert green
        % J(y, x, 3) = 255 - I(y, x, 3); % invert blue
        J(y, x, 3) = I(y, x, 2); % invert blue
    end
end
% show
figure; imshow(J);

for x = 1:width
    for y = 1:height
        % swapping red for green, green for red
        % J(y, x, 1) = 255 - I(y, x, 1); % invert red
        J(y, x, 1) = I(y, x, 2); % invert red
        J(y, x, 2) = I(y, x, 1); % invert green
        % J(y, x, 3) = 255 - I(y, x, 3); % invert blue
        J(y, x, 3) = I(y, x, 3); % invert blue
    end
end
% show
figure; imshow(J);

for x = 1:width
    for y = 1:height
        % swapping red for green, green for red
        % J(y, x, 1) = 255 - I(y, x, 1); % invert red
        J(y, x, 1) = I(y, x, 2); % invert red
        J(y, x, 2) = I(y, x, 3); % invert green
        % J(y, x, 3) = 255 - I(y, x, 3); % invert blue
        J(y, x, 3) = I(y, x, 1); % invert blue
    end
end
% show
figure; imshow(J);


