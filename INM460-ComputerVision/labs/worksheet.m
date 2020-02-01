% INM460 / IN3060
% Computer Vision Mathematics Worksheet
% Drs Greg Slabaugh and Sepehr Jalali City University London
% https://moodle.city.ac.uk/mod/resource/view.php?id=1314634

% This worksheet contains a set of questions related to mathematics for
% computer vision.

% Question 1
% Let two 2D points be p = [1; 1]T and q = [3; 4]T , and let c = 3 be a scalar
% value.

% 1.1
% What is the distance d between p and q?
p = [1; 1]';
q = [3; 4]';
d = norm(p-q);
% or
d = pdist2(p,q); % help pdist2 - defaults to euclidean distance

% 1.2
% Find a vector t, that starts at p and ends at q.
t = q - p;

% 1.3
% Find t hat, a normalised version of t.

