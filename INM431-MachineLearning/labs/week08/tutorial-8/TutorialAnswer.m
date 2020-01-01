clear;
% Part b
% Load the data for the ‘Old Faithful’ geyser dataset by typing load ('faithful');
load 'faithful.mat';
% Visualise the dataset by using the Matlab built-in plot() function. 
% Plot the first column versus the second column and make sure to use '.' as an option in the function.

figure;
plot(X(:,1), X(:,2), '.') 
% Standardize the data (make sure that each variable has zero mean and unit variance) using the standardizeCols() 
% function found in the .zip file. Visualise the standardized dataset.
X = standardizeCols(X);
[mu, assign] = kmeansFit(X, 2, 'maxIter', 10);

% Visualise the standardized dataset.

% Based on the results from the clustering step, visualise the clusters using 
% function plotKmeansClusters()
plotKmeansClusters(X, mu, assign)


    