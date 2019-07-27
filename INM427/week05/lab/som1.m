% Simple example of self-organizing maps

x = simplecluster_dataset;
net = selforgmap([5 5]);
net = train(net,x);
plotsompos(net);