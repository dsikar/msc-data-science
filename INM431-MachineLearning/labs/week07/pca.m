% Thanks to Mark Richardson
X = [105 103 103 66; 245 227 242 267; 685 803 750 586;
147 160 122 93; 193 235 184 209; 156 175 147 139;
720 874 566 1033; 253 265 171 143; 488 570 418 355;
198 203 220 187; 360 365 337 334; 1102 1137 957 674;
1472 1582 1462 1494; 57 73 53 47; 1374 1256 1572 1506;
375 475 458 135; 54 64 62 41];
covmatrix=X*X'; 
data = X; 
[M,N] = size(data); 
mn = mean(data,2);
data = data - repmat(mn,1,N); Y = data' / sqrt(N-1); 
[u,S,PC] = svd(Y);
S = diag(S); V = S .* S; signals = PC' * data;
%plot first component:
plot(signals(1,1),0,'b.',signals(1,2),0,'b.',...
signals(1,3),0,'b.',signals(1,4),0,'r.','markersize',15)
xlabel('PC1')
text(signals(1,1)-25,-0.2,'Engl'),text(signals(1,2)-25,-0.2,'Wales'),
text(signals(1,3)-20,-0.2,'Scot'),text(signals(1,4)-30,-0.2,'N Ireland')
%to plot first and second components, remove comment symbols below:
%plot(signals(1,1),signals(2,1),'b.',signals(1,2),signals(2,2),'b.',...
%signals(1,3),signals(2,3),'b.',signals(1,4),signals(2,4),'r.',...
%'markersize',15)
%xlabel('PC1'),ylabel('PC2')
%text(signals(1,1)+20,signals(2,1),'England')
%text(signals(1,2)+20,signals(2,2),'Wales')
%text(signals(1,3)+20,signals(2,3),'Scotland')
%text(signals(1,4)+60,signals(2,4),'N Ireland')%
disp(PC)
disp(V)



