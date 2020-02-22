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