% Assume you have been given training data f(i1, i2)g where (0.7, 0.3), (0.4, 0.5) and (0.6, 0.9)
% have passed the examination (i.e. have target output 1) and (0.2, 0.2) has failed the examination
% (i.e. has target output 0). Train a perceptron on this data using eta = 0.1 and initial weight vector
% (Theta, Wi1, Wi2) = (-0.5, 0.3,-0.2)

% initial weights - bias (theta), wk1, wk2
weights = [-0.5,0.3,-0.2];
% inputs - NB bias input set to +1
inputs = [1 0.7 0.3; 1 0.4 0.5; 1 0.6 0.9; 1 0.2 0.2];
% inputs(4:4,:)
targets = [1 1 1 0];
% targets(i)
learning_rate = 0.1;


% plot boilerplate code
%clear
clf
% keep plot on
hold on;
% set plot limits
plot_min = -0.5;
plot_max = 1.5;
% x values, to give us y values for our line plots
x = linspace(plot_min, plot_max, 100);
% set size to unit square
xlim([plot_min,plot_max]);
ylim([plot_min,plot_max]);
% plot title
title("Perceptron learning algorithm")
% plot points
% pass
plot(inputs(1:1,2:2), inputs(1:1,3:3), 'o');
text(inputs(1:1,2:2), inputs(1:1,3:3), 'pass');
plot(inputs(2:2,2:2), inputs(2:2,3:3), 'o');
text(inputs(2:2,2:2), inputs(2:2,3:3), 'pass');
plot(inputs(3:3,2:2), inputs(3:3,3:3), 'o');
text(inputs(3:3,2:2), inputs(3:3,3:3), 'pass');
% fail
plot(inputs(4:4,2:2), inputs(4:4,3:3), 'o');
text(inputs(4:4,2:2), inputs(4:4,3:3), 'fail');
% plot current classification boundary to see how we started
plot_classification_boundary(weights, x);

% train network over 4 epochs
epochs = 4;
for i = 1:epochs
    weights = epoch_weights(weights, inputs, targets, learning_rate);
    % plot line so we can see how it is being adjusted by the learning
    % algorithm
    plot_classification_boundary(weights, x)
end
        
% ===== MODULE FUNCTIONS ========

% epoch_weights - run all examples through the perceptron learning algorithm
% and return new weights
function y = epoch_weights(weights, inputs, targets, learning_rate)
    for i = 1:4
        % hardlim == step == heaviside function
        output = hardlim(dot(weights, inputs(i:i,:)));
        % dw = n(t-o)I
        % where n = learning rate, t = target, o = output and I = input
        % vector
        dw = learning_rate*(targets(i)-output)*inputs(i:i,:);
        % new weights
        weights = weights + dw;
        % disp(v)
    end
    y = weights;
end

% plot current classification boundary to see how we are getting on
% set visible plot x y limits to unit square
function plot_classification_boundary(weights, x)
    % plot line
    y = (-(weights(2)*x) - weights(1))/weights(3);
    plot(x,y);
end