% Artur's solution
clear all;
load hospital;
hospital.SysPressure = hospital.BloodPressure(:,1);
hospital.DiaPressure = hospital.BloodPressure(:,2);
numeric_data=[hospital.Age,hospital.Weight,hospital.DiaPressure,hospital.SysPressure];
disp('covariance matrix')
cov(numeric_data)
disp('correlation matrix')
corrcoef(numeric_data)


a = 0;
b = 6;
% generate 1000 random numbers in the range 1 to 6
r = round((b-a).*rand(1000,1) + a + 0.5);
disp(sum(r)/1000)
    3.4840
