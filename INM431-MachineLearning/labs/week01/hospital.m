% Artur's solution
clear all;
load hospital;
hospital.SysPressure = hospital.BloodPressure(:,1);
hospital.DiaPressure = hospital.BloodPressure(:,2);
numeric_data=[hospital.Age,hospital.Weight,hospital.DiaPressure,hospital.SysPressure];
figure;
disp('covariance matrix')
cov(numeric_data)
disp('correlation matrix')
corrcoef(numeric_data)


