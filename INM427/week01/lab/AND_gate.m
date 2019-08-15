% AND gate neural network
% We'll try to do this by creating a custom shallow network

% create network
net = network;

% view network
% view(net); % empty network

% Add two inputs and one layer
%net.numInputs = 2;
%net.numLayers = 1;
%net.biasConnect(1) = 1;
net = network(2,1,1);

% net.inputConnect = [1; 0];


view(net);


% net = network(1,2,[1;0],[1; 0],[0 0; 1 0],[0 1])
% net = network(numInputs,numLayers,biasConnect,inputConnect,layerConnect,outputConnect) 
% numInputs = 1
% numLayers = 2
% biasConnect = [1; 0]
% inputConnect = [1; 0]
% layerConnect = [0 0; 1 0]
% outputConnect = [0 1]