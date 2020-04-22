%cropface(I, minsize)
% I - image
% minsize - minimum size to be searched
% Return cropped face
%
% Example:
% cropped = cropface(I, [200 200]);
% ================ Start code ================
function img = cropface(I, minsize)
    % initialise return variable
    img = [];
    % minsize = [200 200];
    FaceDetector = vision.CascadeObjectDetector(); % test - ignore 'MinSize', minsize);
    % get bounding boxes
    bbox = step(FaceDetector, I);
    [x,y] = size(bbox);
    if x > 0
        a = bbox(1, 1);
        b = bbox(1, 2);
        c = a+bbox(1, 3);
        d = b+bbox(1, 4);
        % scale image if required
        img = I(b:d, a:c, :);
    end    
end
% ================ End code ================