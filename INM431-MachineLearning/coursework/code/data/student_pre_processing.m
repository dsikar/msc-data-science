%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INM431 Machine Learning Coursework %%
%% Daniel Sikar - PT2                 %%
%% Data pre-processing                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO See student.zip for data pre-processing README.txt

% clear environment
clear; clc;

% 1. Load data

x = readtable('student-merged-all-records.csv');
% size(T) ~ 1044 rows x 33 columns
% According to authors, there are some students that belong to both
% datasets. 
% Are there any duplicates across all columns?
[u,I,J] = unique(x, 'rows', 'first')
hasDuplicates = size(u,1) < size(x,1)
ixDupRows = setdiff(1:size(x,1), I)
dupRowValues = x(ixDupRows,:) % empty table
% No

% However, authors say there are duplicates (student-merge.R) based on columns
% 1,2,3,4,5,6,7,8,9,10,11,20,22
% "school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet"
% Let's check
x2 = x(:,[1 2 3 4 5 6 7 8 9 10 11 20 22])
[u,I,J] = unique(x2, 'rows', 'first')
hasDuplicates = size(u,1) < size(x2,1)
ixDupRows = setdiff(1:size(x2,1), I)
dupRowValues = x2(ixDupRows,:)  % yes, 382
% We will have to deal with duplicates at some point

% From a binary classification perspective, column G3 is the label, where 
% G3 >= 10 represents a pass, and
% G3 < 10 represents a fail

% Let's look at the spreads for final grades G3:

[a,b] = histc(x.G3,unique(x.G3));
G3vec = unique(b);
G3vec(:,2) = a;
disp(G3vec); % results grouped by final grade e.g. 53 students graded 0, etc

% count total students with final grade < 10 (fail)
fail = sum(G3vec(G3vec(:,1)<10,2));
disp(fail)
% count total number of students with final grade >= 10
total = sum(G3vec(:,2));
pass = total - fail;
disp(pass)
% fail %
display(fail/total) % 0.2203
% pass %
display(pass/total) % 0.7797

x.Result = x.Medu; % add a column by copying existing one
x.Result(x.G3 < 10) = 0 % update
x.Result(x.G3 > 9) = 1 % update

% Save table
writetable(x, 'student-labelled.csv');

% given there is over 1 in 5 failure rate, we will not consider boosting
% the minority class "fail" - question for Artur, when should we consider
% boosting?


