% clear all local variables
clear all;
% Covariance and correlation 
% Read the text - http://ci.columbia.edu/ci/premba_test/c0331/s7/s7_5.html
% 1. Load the hospital dataset
load hospital; 
hospital.Properties.VarNames(:);
systolic = hospital.BloodPressure(:,1);
diastolic = hospital.BloodPressure(:,2);
weight = [hospital.Weight];
age = [hospital.Age];

% https://www.cdc.gov/bloodpressure/measure.htm
% We'll use diastolic pressure as a measure of blood pressure
% sistolic - pressure in your blood vessels when your heart beats
% diastolic - pressure in your blood vessels when your heart rests between beats
% "health care professionals sometimes look at high systolic blood pressure 
% levels as a bigger risk factor for heart disease"

% a. Calculate the covariance between weight and blood pressure in patients

% Covariance
% Covariance indicates how two variables are related. A positive covariance 
% means the variables are positively related, while a negative covariance 
% means the variables are inversely related.

cov(weight, systolic) % doc cov

% C=( cov(A,A) cov(B,A)
%     cov(A,B) cov(B,B) )

%  706.0404   27.7879
%   27.7879   45.0622

% cov(weight, systolic) = 27.79

% corrcoef(weight, systolic)
%    1.0000    0.1558
%    0.1558    1.0000

% a. Calculate the correlation coefficient between age and blood pressure in patients

% Correlation
% Correlation is another way to determine how two variables are related. 
% In addition to telling you whether variables are positively or inversely 
% related, correlation also tells you the degree to which the variables tend to move together.
% NB Normalised by product of standard deviations of dependent and
% independend variables, results in range -1 to 1

corrcoef(age, systolic)

%    1.0000    0.1341
%    0.1341    1.0000

% cov(numeric_data)
%   52.0622    6.4966
%    6.4966   45.0622
