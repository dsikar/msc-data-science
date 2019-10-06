% INM431 Machine Learning
% Decision Trees - What to do

% clear all
clear all;
% clear command window
clc;
% get decision data - had to add 7x rows to get the full tree
data = readtable("what_to_do.txt",'ReadVariableNames', false); 
% set column headers
VarNames = ["Weather","Parents_Visiting","Money","Decision"];
data.Properties.VariableNames = VarNames;
% Create decision tree
ctree = fitctree(data, 'Decision');
% view graph
view(ctree,'Mode','graph')
% view rules
view(ctree,'Mode','text')

