%
% Building a neural net with one hidden layer to train an XOR function
%
% This is actually the wrong approach, as weights are known already

% Clear workspace
clear

% Create XOR input and target dataset
inputs = [0 0; 0 1; 1 0; 1 1];
targets = [0; 1; 1; 0];

% Transpose - train function expects this format - inputs as columns,
% output as vector of dimension 1 row * n columns
x = inputs';
t = targets';

% Create net with two nodes in one hidden layer
% Altenatively, fitnet([10,8,5]) - 3 hidden layers, where the first hidden 
% layer size is 10, the second is 8, and the third is 5
% https://uk.mathworks.com/help/deeplearning/ref/fitnet.html
xornet = fitnet(2);

% Train
xornet = train(xornet, x, t);

% View
view(xornet);

% Estimate targets
y = xornet(x);
% 0.8571    0.8077    0.7766    0.5144
% These estimates show that the output is continuous, so we need to
% adjust our network to output discrete values, so we'll change the output
% activation function to hardlim
% So let's find out what are the activation functions at the moment
%xornet.layers{1}.transferFcn;
%'tansig'
%xornet.layers{2}.transferFcn;
% 'purelin'
% let's reconfigure the network - step function as activation function
% for hidden and output layer
xornet.layers{1}.transferFcn = 'hardlim';
xornet.layers{2}.transferFcn = 'hardlim';

% Double check
view(xornet);

% Retrain network
xornet = train(xornet, x, t);

% check performance - just as bad
y = xornet(x);
perf = perform(xornet,y,t)
