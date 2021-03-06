% studying the peaks function, specially "translating and
% scaling Gaussian distributions" - see help peaks for details
clear all;
clc;
% NB peaks will run meshgrid(linspace(-3,3,arg1))
% linspace(-3,3,3)
% x = meshgrid([-3 0 3]);
% linspace(-3,3,5)
% x = meshgrid([-3.0000 -1.5000 0 1.5000 3.0000]);
x = meshgrid(linspace(-3,3,49)) % 49 default for peaks()
y = x';
za = 3*(1-x).^2.*exp(-(x.^2) - (y+1).^2);
zb = 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2);
zc = 1/3*exp(-(x+1).^2 - y.^2);
zd = za - zb - zc;
figure;
surf(x,y,za); % open surf
axis('tight')
xlabel('x'), ylabel('y'), title('surf(x,y,za); za = 3*(1-x).^2.*exp(-(x.^2) - (y+1).^2);')
figure;
surf(x,y,zb); 
axis('tight')
xlabel('x'), ylabel('y'), title('surf(x,y,zb); zb = 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2);')
figure;
surf(x,y,za-zb); 
axis('tight')
xlabel('x'), ylabel('y'), title('surf(x,y,za-zb);')
figure;
surf(x,y,zc); 
axis('tight')
xlabel('x'), ylabel('y'), title('surf(x,y,zc); zc = 1/3*exp(-(x+1).^2 - y.^2);')
figure;
surf(x,y,zb-zc); 
axis('tight')
xlabel('x'), ylabel('y'), title('surf(x,y,zb-zc);')
figure;
surf(x,y,zd); 
axis('tight')
xlabel('x'), ylabel('y'), title('surf(x,y,zd); zd = za - zb - zc;')