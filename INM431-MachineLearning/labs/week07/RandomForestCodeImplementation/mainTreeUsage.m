close all
clear all
clc

%load sampleData;
% x = -20:20;
% y= x.^2;

y = ReadMatFromFile('toyLabel.dat');
x = ReadMatFromFile('toyData.dat');

plot(x, y, 'o');
axis equal;
grid on;
hold on;

myTree = RTree(20, 10);
myTree.trainTree(x, y);


outX = 200:800;
outY = zeros(size(outX));
outC = zeros(size(outX));
for i = 1:size(outX,2)
    outNode  = myTree.predictTree(outX(i));
    outY(i) = outNode.m_mean;
    outC(i) = outNode.m_cov;
end

plot(outX, outY, 'ro');
plot(outX, outY+sqrt(outC), 'g.');
plot(outX, outY-sqrt(outC), 'g.');

myForest = RForest(10);
myForest.trainRF(x, y);


for i = 1:size(outX,2)
    outNode  = myForest.predictRF(outX(i));
    outY(i) = outNode.m_mean;
    outC(i) = outNode.m_cov;
end

figure;
plot(x, y, 'o');
axis equal;
grid on;
hold on;

plot(outX, outY, 'ro');
plot(outX, outY+sqrt(outC), 'g.');
plot(outX, outY-sqrt(outC), 'g.');