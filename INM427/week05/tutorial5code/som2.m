% Example of SOM with uniform distribution and 100 neurons
% Click on 'SOM weight positions' while training for special effects!!

x = rand(2, 2000);
scatter(x(1,:), x(2,:)); 
net = selforgmap([10 10], 150, 50, 'hextop', 'boxdist');
net = train(net,x);
plotsompos(net);

% selforgmap(dimensions,coverSteps,initNeighbor,topologyFcn,distanceFcn)
% dimensions   = Row vector of dimension sizes
% coverSteps   = Number of training steps for initial covering of the input space
% initNeighbor = Initial neighborhood size
% topologyFcn  = Layer topology function
% distanceFcn  = Neuron distance function