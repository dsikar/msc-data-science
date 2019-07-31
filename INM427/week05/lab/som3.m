% Example of SOM with randomly sparsed data points
% Click on 'SOM weight positions' while training for special effects!!

x = rand(2, 1000);

% cut-off of half, triangle-shaped
for i=1:1000, %x
    if (x(2,i) > x(1,i)),
        x(2,i) = x(1,i);
    end;
end;
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