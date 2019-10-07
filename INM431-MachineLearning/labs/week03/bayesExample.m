clear all; clc; close all;

% Example of Bayesian Inference on 2 normal distributions

x = linspace(0,10,1000);
figure; hold on; axis([0 10 0 1]);

 % Prior distribution 
pm = 5; % Prior mean
ps2 = 4; % Prior variance
prior = (2*pi*ps2)^(-0.5)*exp(-0.5*(x-pm).^2/ps2);
plotPrior = plot(x,prior,'k'); % Plot 1: prior distribution
leg = legend('prior');

% Number of recursive iterations
for i = 1:10,
    % Likelihood function 
    lm = 6; % sample mean
    ls2 = 3; % sample variance
    plotSample = plot(lm, 0, 'bx', 'MarkerSize', 16); % Plot 2: sample mean
    leg = legend('prior', 'measurement');
    
    like = (2*pi*ls2)^(-0.5)*exp(-0.5*(x-lm).^2/ls2);
    plotLike = plot(x,like); % Plot 3: sample distribution
    leg = legend('prior', 'measurement', 'likelihood');

    Ps2 = (1/ps2 + 1/ls2)^(-1);
    Pm = Ps2*(pm/ps2 + lm/ls2);
    posterior = (2*pi*Ps2)^(-0.5)*exp(-0.5*(x-Pm).^2/Ps2);
    plotPost = plot(x, posterior, 'r'); % Plot 3: product distribution
    leg = legend('prior', 'measurement', 'likelihood', 'posterior');
    
    if(i < 10),
    
        pause(1);

        delete(get(leg, 'Children'));

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
