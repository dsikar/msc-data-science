%%%%%%%%%%%%%%%%%%
%% bnet adapted %%
%% student data %%
%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

% Datasets
% student-mat.csv
% student-por.csv

% There are some duplicates across both sets. The authors supplied an R
% script do deal with it - student-merge.R
% For the time being we'll just
% manipulate the data and start looking at it.

T = readtable('../student/student-mat.csv');
% select 10 numeric rows, ideally binary, to run a test

 % T(2:end,[3 7 8 13 14 15 24 25 26 27 28 29 30]);
 % T(2:end,[3 7 8 13 14 15 24 25 26 27]

% Bayesian Network Structure building example - K2 algorithm
% The sample example must have variables as columns and observations as
% rows

% sample = csvread('sample.csv');
T_numeric = T(2:end,[3 7 8 13 14 15 24 25 26 27]);
sample = table2array(T_numeric)
% Sample is a variable that saves our training database.
LGObj = ConstructLGObj(sample); % construct an object

Order = [3 4 1 2 5 8 7 10 9 6]; % Order is the ordering of the input in K2 algorithm

u = 4; % n = u+1 where n is the maximum number of parents.

[ DAG,K2Score ] = k2( LGObj,Order,u )
h = view(biograph( DAG )) % requires bioinformatics toolbox