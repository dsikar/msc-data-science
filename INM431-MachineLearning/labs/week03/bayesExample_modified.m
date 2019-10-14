clear all; clc; close all;

% Example of Bayesian Inference on 2 normal distributions

x = linspace(0,10,1000);
% x = ones(1,1000,1);
figure; hold on; axis([0 10 0 1]);

% Prior distribution - replace distribution to uniformly distruted prior
pm = 5; % Prior mean
ps2 = 4; % Prior variance
% Slide 3, lecture 2
prior = (2*pi*ps2)^(-0.5)*exp(-0.5*(x-pm).^2/ps2); % TASK Change prior so we get one for each data point
plotPrior = plot(x,prior,'k'); % Plot 1: prior distribution
leg = legend('prior');

% Number of recursive iterations
for i = 1:10,
    % Likelihood function 
    lm = 6; % sample mean
    ls2 = 3; % sample variance
    plotSample = plot(lm, 0, 'bx', 'MarkerSize', 16); % Plot 2: sample mean
    leg = legend('prior', 'measurement');
    % TASK 2 - change this to linearly distributed posterior
    like = (2*pi*ls2)^(-0.5)*exp(-0.5*(x-lm).^2/ls2);
    % like = x1; %(2*pi*ls2)^(-0.5)*exp(-0.5*(x-lm).^2/ls2);
    % matlab pointwise 
    plotLike = plot(x,like); % Plot 3: sample distribution
    leg = legend('prior', 'measurement', 'likelihood');
    % posterior
    Ps2 = (1/ps2 + 1/ls2)^(-1); % Formulas not given in lecture notes
    % mean 
    Pm = Ps2*(pm/ps2 + lm/ls2);
    % Lecture 2 page 3
    posterior = (2*pi*Ps2)^(-0.5)*exp(-0.5*(x-Pm).^2/Ps2);
    plotPost = plot(x, posterior, 'r'); % Plot 3: product distribution
    leg = legend('prior', 'measurement', 'likelihood', 'posterior'); % doc legend
    
    if(i < 10),
    
        pause(1);

        delete(get(leg, 'Children')); % doc get, >> get(leg) Children: [0×0 GraphicsPlaceholder]

        delete(plotPrior);
        delete(plotLike);
        delete(plotPost);
        delete(plotSample);

        prior = posterior; % Plot 3: product distribution 
        pm = Pm;
        ps2 = Ps2;

        plotPrior = plot(x,prior,'k'); % Plot 1: prior distribution
        leg = legend('prior');
    end;
end;
