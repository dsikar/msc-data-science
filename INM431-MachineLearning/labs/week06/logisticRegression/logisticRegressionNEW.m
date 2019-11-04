close all; clear all; clc;

hold on;

%Example of Logistic Regression

%Each y value is the number of successes in corresponding number of trials
%n, and x contains the predictor variable values.
x = linspace(-1, 1, 50);
%n = [48 42 31 34 31 21 23 23 21 16 17 21]';
y = x.*x.*x.*x;

distribution = 'gamma';
link = 'log';

%Fit a probit regression model for y on x.
b = glmfit(x,y,distribution, 'link', link);

%Compute the estimated number of successes and plot the percent observed
%and estimated percent success versus the x values.
yfit = glmval(b,x,link);
plot(x,y,'o','LineWidth',2);
p1 = plot(x, yfit,'c', 'LineWidth',2);
p2 = plot(x, y,'r');

leg = legend([p1 p2], strcat(distribution,' fitting curve'),'data distribution');
