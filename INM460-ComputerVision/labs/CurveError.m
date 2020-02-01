function error = CurveError(t, p)
    a = t(1);
    b = t(2);
    L = size(p, 1);
    for i= 1:L
        x = p(i, 1);
        y = p(i, 2);
    error(i) = a + b*x +a*b*x^2 -y;
end