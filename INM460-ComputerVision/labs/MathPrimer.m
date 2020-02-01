clear;
clc;
% a matrix
M = [9, -2; -3, -4];
% multiplied by its inverse, if matrix is invertable
I = M*inv(M);
% gives the identity matrix
disp(I);

% Solving a system of linear equations
A = [2, 3; 4, 9];
b = [6, 15]';
x = inv(A)*b;
disp(x);

% Overdetermined system
A = [1, 1; 3, 1; 5, 1];
d = [1; 4; 5];
% Since A is not a square matrix, we cannot invert it, however, we may use
% the pseudo-inverse ie. inv(A'*A)*A'

c = pinv(A)*d;

% visualise the result
m = c(1);
b = c(2);
x = [1:6];
y = m*x+b;
% plot(x,y);
hold on;
% scatter(A(:, 1), d);

% Example (rigid body transformation)
p1 = [3, 0, 1]'; % note we added w = 1, to make p1 a homogeneous coordinate
tx= 3;
ty = 2;
theta = deg2rad(90);
T = [cos(theta), -sin(theta), tx;...
sin(theta), cos(theta), ty; 0, 0 1];
q1 = T*p1

% alternatively, using affine2d class, noting transpose of matrix is
% required

T = affine2d(...
[cos(theta), -sin(theta), tx;...
sin(theta), cos(theta), ty; ...
0, 0 1]'); % transpose for affine2d function
[x, y] =transformPointsForward(T,3,0)

% derivatives
x = [1:100];
f = 5*x.^2+5*x+5;
% plot(x,f);
a = 50; % A point to analyse
hold on;
% scatter(x(a), f(a));

% Plot tangent at a
% first derivative
f_x= 10*x+5;
m = f_x(a); % where a = 50, 10*x+5 = 505
xx = [x(a)-10:x(a)+10]; % columns from 40 to 60
% center xx around 0 ~ x(a) = 50
% zero-center xx-x(a) ~ ... -2    -1     0     1     2 ...  
% f(x(a)) = 12755 ~ evaluated for f = 5*x.^2+5*x+5
% 12755 * 505 * x ~ 7705        8210        8715 ...
% Ask Alex
y = f(x(a))+m*(xx-x(a)); 
% plot(xx, y);

% Taylor series expansion
x = [1:100];
f = 5*x.^2+5*x+5;
f_x= 10*x + 5;
f_xx= 10*ones(size(x));
%plot(x,f); hold on;
a = 50; % A point to analyse
%scatter(x(a), f(a));

x = [x(a)-10:x(a)+10];
% First order approximation at a
f_first= f(a) + f_x(a)*(x-a);
h = plot(x, f_first);
set(h, 'LineWidth', 2);
% Second order approximation at a
f_second= f(a) + f_x(a)*(x-a)+0.5*f_xx(a)*(x-a).^2;
%h = plot(x, f_second);
%set(h, 'LineWidth', 2);

% run in separate script
% Nonlinear optimisation example
p = [1, 1; 3, 4; 5, 5];
t0 = [0, 0];
topt= lsqnonlin(@(t)CurveError(t, p), t0);
a = topt(1);
b = topt(2);
x = [1:.1:5];
f = a+b*x+a*b*x.^2;
plot(x, f);
hold on;
scatter(p(:, 1), p(:, 2));

% run in separate script
% integral as sum

x = [1:100];
f = x.^2;
plot(x, f);

% Between 20 and 80, sample f(x) every dx
% units and multiply by box width (dx)
a = 20;
b = 80;
dx = 5;
intfx= 0;
for xx = a:dx:b-dx
 intfx = intfx + f(xx) * dx;
end

