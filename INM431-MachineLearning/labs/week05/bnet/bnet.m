% From
% https://www.mathworks.com/matlabcentral/fileexchange/23273-k2-algorithm-for-learning-dag-structure-in-bayesian-network
close all; clear all; clc;

% Bayesian Network Structure building example - K2 algorithm
% The sample example must have variables as columns and observations as
% rows
% mathworks
sample = csvread('sample.csv');
% flu


% Sample is a variable that saves our training database.
LGObj = ConstructLGObj(sample); % construct an object

% Order = [3 4 1 2 5 8 7 10 9 6]; % Order is the ordering of the input in K2 algorithm
Order = [1 7 10 9 6 4 3 2 5 8];

% u = 4; % n = u+1 where n is the maximum number of parents.
u = 4; % n = u+1 where n is the maximum number of parents.
node_names = ["one" "two" "three" "one" "two" "three" "one" "two" "three" "four"]
[ DAG,K2Score ] = k2( LGObj,Order,u )
% h = view(biograph( DAG ))
h = view(biograph( DAG, Order, node_names ))