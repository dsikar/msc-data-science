x = iris_dataset;
net = selforgmap([10 10]);
net = train(net,x);
plotsompos(net,x)