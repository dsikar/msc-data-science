% load network
load('dan_net3');
img = imread('../images/sandbox_output/22/75_14.JPG');
[class, err] = classify(dan_net3,img);
disp(class);
disp(max(err));

load('SURFSVMMdl');
img = imread('../images/surf_grayscale/02/5d_IMG_2594.JPG');
% more work required, must turn image in SURF feature vector
%[class, err] = classifySURFImage(SURFSVMMdl,img);
%disp(class);
%disp(max(err));