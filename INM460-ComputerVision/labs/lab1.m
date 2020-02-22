% clear all workspaces
clear all;
% clear command window
clc;
% IN3060/INM460 Computer Vision - Lab 1
% Exercise 1
% Evaluate the function x(t) = t2 – 100t + 2500 for t = 10.
% Correct answer: 1600
t = 10;
x = t^2 - 100 * t + 2500;
disp(x);

% Exercise 2
% Using Matlab, see if you can write the code to evaluate the function
% for x = 1 and y = 2, assigning the answer to a variable called f. 
% The correct answer is 2.4222.
x = 1;
y = 2;
f = (x^2 + 2*x*y - cos(x*y))/sqrt(x^2+y^2);
disp(f);

% Exercise 3
% Make a row vector s that samples the function sin(t) for t=0 to 3.14 
% in increments of .2.
x = 0:0.2:3.14;
t = sin(x);
disp(t);

% Exercise 4
% 1. Create a row vector x containing integer numbers from 1 to 30. 
% Create another row vector y containing numbers 1, 0.9, 0.8, 0.7, . . . 0.1, 0 in this order.
x = 1:1:30;
y = 1:-0.1:0;
% 2. From x create:
% a. A new row vector a containing first 10 elements of x
a = x(1:10);
disp(a);
% b. A new row vector b containing elements of x with indexes from 15 to 25
b = x(15:25);
disp(b);
% c. A new row vector c containing elements of x with even indexes.
% create an index with remainder of division of each element by 2
idx = mod(x,2);
% disp(idx);
% select all elements of x where idx evaluates to false i.e. remainder = 0,
% even numbers
c = x(~idx);
disp(c);

% Exercise 5
% Create a 3 by 3 matrix with all ones. 
x = ones(3,3);
disp(x);
% Create an 8 by 1 matrix with all zeros. 
y = zeros(8,1);
disp(y);
% Create a 5 by 2 matrix with all elements equal to 0.37.
z = 0.37;
z = repelem(z, 5,2);
disp(z);

% Exercise 6
% 1. Use a for loop to calculate the sum 1+2+3+...+300. To do this, create a
% variable (e.g. sumAll) that is initialized to 0 before the loop, and increases
% its value inside the loop. After the for loop, output the value of the sum.
% If you code this correctly, the answer is 45150
x = 0;
for y = 1:300
    x = x + y;
end
disp(x);

% 2. Modify your code to calculate the sum 1^2 + 2^2 +3^2 + ... 400^2.
% If you code this correctly, the answer is 21413400
x = 0;
for y = 1:400
    x = x + y^2;
end
disp(x);
    
% Exercise 7:
% Plot the function f(t) = t2 – 100t + 2500 for the range t = [0, 100]. Hint: you can
% define t as a row vector, and use an element-wise multiplication for the t2 term.
% alternatively, t.^2 % sum(t.^2 == t.*t) = 101
t = (0:100);
f = t.*t - 100 * t + 2500; 
plot(t, f);

