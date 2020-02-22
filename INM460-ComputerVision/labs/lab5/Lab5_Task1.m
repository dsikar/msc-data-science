% Task 1: Image matching
% Try to break

original = imread('cameraman.tif');
figure;
imshow(original);
hold on;

ptsOriginal = detectSURFFeatures(original);
originalMarkers = insertMarker(original, ptsOriginal.selectStrongest(10), 'x');
imshow(originalMarkers); 
% plot(pointsI.selectStrongest(10));

scale = 1.3;
J = imresize(original,scale);
theta = 31;
distorted = distortedFace(J); % imrotate(J,theta);
figure
imshow(distorted);
hold on;
ptsDistorted = detectSURFFeatures(distorted);
% plot(pointsJ.selectStrongest(10));
distortedMarkers = insertMarker(distorted, ptsDistorted.selectStrongest(10), 'x');
imshow(distortedMarkers); 

[featuresOriginal,validPtsOriginal] = extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = extractFeatures(distorted,ptsDistorted);

indexPairs = matchFeatures(featuresOriginal,featuresDistorted);

matchedOriginal = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

figure
showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted)
title('Candidate matched points (including outliers)')

[tform, inlierDistorted,inlierOriginal] = ...
estimateGeometricTransform(matchedDistorted,...
matchedOriginal,'similarity');

showMatchedFeatures(original,distorted,inlierOriginal,inlierDistorted)
title('Matching points (inliers only)')
legend('ptsOriginal','ptsDistorted')

outputView = imref2d(size(original));
recovered = imwarp(distorted,tform,'OutputView',outputView);
figure
imshowpair(original,recovered,'montage')

% Exercise 1: Try other, more dramatic distortions (get creative!). Can you break
% the image matching algorithm we just implemented?


