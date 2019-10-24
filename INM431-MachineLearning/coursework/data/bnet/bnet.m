% original
% https://uk.mathworks.com/matlabcentral/fileexchange/23273-k2-algorithm-for-learning-dag-structure-in-bayesian-network

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
% first we select column names and number them, to make it easier to choose
% by index
stColNames = T.Properties.VariableNames;
nCols = size(stColNames,2); % number of columns
nCols = linspace(1, nCols, nCols);
stIndexedColNames = [stColNames; string(nCols)];
%  Columns 1 through 13

%    "school"    "sex"    "age"    "address"    "famsize"    "Pstatus"    "Medu"    "Fedu"    "Mjob"    "Fjob"    "reason"    "guardian"    "traveltime"
%    "1"         "2"      "3"      "4"          "5"          "6"          "7"       "8"       "9"       "10"      "11"        "12"          "13"        

%  Columns 14 through 25

%    "studytime"    "failures"    "schoolsup"    "famsup"    "paid"    "activities"    "nursery"    "higher"    "internet"    "romantic"    "famrel"    "freetime"
%    "14"           "15"          "16"           "17"        "18"      "19"            "20"         "21"        "22"          "23"          "24"        "25"      

%  Columns 26 through 33

%    "goout"    "Dalc"    "Walc"    "health"    "absences"    "G1"    "G2"    "G3"
%    "26"       "27"      "28"      "29"        "30"          "31"    "32"    "33"

% Todo
% 1. Add column descriptions as comments
% 2. Choose appropriate indexes, to include grade columns G1, G2, G3
% 3. Build BN index, probably starting with G3, G2 and G1 (domain
% knowledge)
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

% This might be where we need some domain knowlege, i.e., the grades should
% be at the top of our network
Order = [3 4 1 2 5 8 7 10 9 6]; % Order is the ordering of the input in K2 algorithm

u = 4; % n = u+1 where n is the maximum number of parents.

[ DAG,K2Score ] = k2( LGObj,Order,u )
h = view(biograph( DAG )) % requires bioinformatics toolbox