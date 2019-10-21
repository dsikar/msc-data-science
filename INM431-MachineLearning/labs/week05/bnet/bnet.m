close all; clear all; clc;

% Bayesian Network Structure building example - K2 algorithm
% The sample example must have variables as columns and observations as
% rows
sample = csvread('sample.csv');

% Sample is a variable that saves our training database.
LGObj = ConstructLGObj(sample); % construct an object

Order = [3 4 1 2 5 8 7 10 9 6]; % Order is the ordering of the input in K2 algorithm

u = 4; % n = u+1 where n is the maximum number of parents.

[ DAG,K2Score ] = k2( LGObj,Order,u )
h = view(biograph( DAG ))