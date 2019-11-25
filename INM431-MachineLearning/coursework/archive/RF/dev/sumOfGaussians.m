x = [-3:.1:3];
y1 = normpdf(x,0,1);
y2 = normpdf(x,-0.5,1);
plot(x,y1)
figure
hold on
plot(x,y1)
plot(x,y2)
plot(x,y2+y1)