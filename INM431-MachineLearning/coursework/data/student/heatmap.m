close all; clear all; clc;

% Datasets
% student-mat.csv
% student-por.csv

% Initial investigation
T = readtable('../student/student-mat.csv');

% h = heatmap(T,'traveltime','G3')

load patients
tbl = table(LastName,Age,Gender,SelfAssessedHealthStatus,Smoker,Weight,Location);
h = heatmap(tbl,'Smoker','SelfAssessedHealthStatus');