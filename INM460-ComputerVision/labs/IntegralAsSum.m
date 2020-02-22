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