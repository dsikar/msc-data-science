% INM460 Lab - week 2 - Task 2
function [ f ] = function1( x, y )
    %function1 evaluates my function for any x and y
    f = (x^2+2*x*y-cos(x*y)) / (sqrt(x^2+y^2));
end