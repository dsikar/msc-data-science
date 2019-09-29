% INM431 Machine Learning
% Week 1 lab
% https://moodle.city.ac.uk/mod/resource/view.php?id=1422696

% clear all local variables
clear all;
% clear command window
clc;

% Covariance and correlation 
% Read the text - http://ci.columbia.edu/ci/premba_test/c0331/s7/s7_5.html
% 1. Load the hospital dataset
load hospital; 
hospital.Properties.VarNames
systolic = hospital.BloodPressure(:,1); % from doc colon, A(:,n) is the nth column of matrix A
diastolic = hospital.BloodPressure(:,2); 
weight = hospital.Weight;
age = hospital.Age;

% From https://www.cdc.gov/bloodpressure/measure.htm
% sistolic - pressure in your blood vessels when your heart beats
% diastolic - pressure in your blood vessels when your heart rests between beats
% "health care professionals sometimes look at high systolic blood pressure 
% levels as a bigger risk factor for heart disease"
% We'll use sistolic pressure as a measure of blood pressure

% a. Calculate the covariance between weight and blood pressure in patients

% Covariance - from http://ci.columbia.edu/ci/premba_test/c0331/s7/s7_5.html
% Covariance indicates how two variables are related. A positive covariance 
% means the variables are positively related, while a negative covariance 
% means the variables are inversely related.

% From 
% doc cov
% C = cov(A,B) returns the covariance between two random variables A and B. 
% If A and B are vectors of observations with equal length, cov(A,B) is the 2-by-2 covariance matrix
disp("Covariance matrix: weight x systolic blood pressure")
cov(weight, systolic) 

% C=( cov(A,A) cov(B,A)
%     cov(A,B) cov(B,B) )

%  706.0404   27.7879
%   27.7879   45.0622

% covariance (weight, systolic) = 27.79

% b. Calculate the correlation coefficient between age and blood pressure in patients

% Correlation 
% Correlation is another way to determine how two variables are related. 
% In addition to telling you whether variables are positively or inversely 
% related, correlation also tells you the degree to which the variables tend to move together.
% Correlation standardizes the measure of interdependence between two variables and, consequently, 
% tells you how closely the two variables move. The correlation measurement, called a correlation 
% coefficient, will always take on a value between 1 and – 1:
% NB Correlation Coefficient is Covariance devided by the product of
% standard deviations http://ci.columbia.edu/ci/premba_test/c0331/images/s7/6527381492.gif

% From
% >> doc corrcoef

% The correlation coefficient matrix of two random variables is the matrix of correlation 
% coefficients for each pairwise variable combination,

% R= ( ?(A,A) ?(B,A)
%      ?(A,B) ?(B,B) )

% Since A and B are always directly correlated to themselves, the diagonal entries are just 1, that is, 
% R=( 1      ?(B,A)
%     ?(A,B) 1     ).

disp("Correlation coefficient matrix: age x systolic blood pressure")
corrcoef(age, systolic)

%    1.0000    0.1341
%    0.1341    1.0000

% correlation coefficient (age, systolic) = 0.1341

% Optional (advanced): Find Standard Deviations from Covariance Matrix

% From 
% doc cov
% C = cov(A)
% If A is a matrix whose columns represent random variables and whose rows represent observations, 
% C is the covariance matrix with the corresponding column variances along the diagonal.
% From
% doc std
% The standard deviation is the square root of the variance. 

disp("Standard deviations: weight and systolic blood pressure")
sqrt(diag(cov(weight, systolic)))



