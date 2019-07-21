% Example of winning neuron in a SOM (self organising map)

% Every neuron is represented as a vector, with synaptic weights from all
% neurons that connect to it, plus from the connection to itself (bias)

% 3 neurons connected to each other (2 connections each), plus one
% connection to itself (bias) making for a total of 3 synaptic weights per
% neuron, that is to say, each neuron is represented by a weight vector

n1 = rand(1,3);
n2 = rand(1,3);
n3 = rand(1,3);

% The dimensionality of the input vector matches the dimensionality of the
% weight vectors

i1 = rand(1, 3);

% The winning neuron is the one whose weight vector is closest to input
% vector

% From the matlab (docsearch euclidean) documentation:
% Algorithms
% The Euclidean distance d between two vectors X and Y is

% d = sum((x-y).^2).^0.5
dn1 = sum((n1-i1).^2).^0.5; % 1.0496
dn2 = sum((n2-i1).^2).^0.5; % 0.8021
dn3 = sum((n3-i1).^2).^0.5; % 0.6869 % winning neuron n3 has shortest euclidean distance to i1 input vector
                            % Note 0.6869 will also be the magnitude of
                            % vector nWin
nWin = n3-i1; % 
% winner is n3 (result will change with every run as we are dealing with random
% numbers), that is to say the euclidian distance of input vector i1 is
% shortest (nearest) to n3.
% If we look at the vector magnitudes (euclidean lengths) we get:
% norm(n1) = 1.2185
% norm(n2) = 0.2879
% norm(n3) = 0.7452
% norm(i1) = 1.0841
% norm(nWin) = 0.6869

% clear the figure
clf;

% hold the plot
hold on;

% we plot the 3 neurons in 3-d space

plotv([n1;n2;n3;nWin],'-');


% Some more notes on Euclidian distance

% The Euclidean distance d between two vectors X and Y is

% d = sum((x-y).^2).^0.5
% that is to say, the square root of the square of the differences.

% x = [1 1 1] ~ points to corner opposite to origin in unit cube
% y = [1 1 0] ~ point to corner opposito to origin in unit cube, on x,y
% plane
% expected euclidian distance is 1 i.e., distance from two corners
% described.
% sum((x-y).^2).^0.5

% ans =

%     1

% The actual vector would be the difference of both vectors i.e. x - y.