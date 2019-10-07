clear all; clc; close all;

% Example of Bayesian Inference on 2 normal distributions

x = linspace(-2, 2, 1000);
figure; hold on; axis([-1 3 0 10]);

 % Prior distribution 
prior = unifpdf(x, 0, 1) ; % Uniform prior between 0 and 1
plotPrior = plot(x,prior,'k') ; % Plot 1: prior distribution
leg = legend('prior') ;

% Simulation of the 100 coin tosses
p = 0.6; % probability of heads (you can change it if you want)
n = 100; % number of tosses (you can change this as well to see the effect of sample size on the estimate)
tosses = rand(1, n); % generate n random numbers between 0 and 1
tosses = (tosses<p); % transform the numbers between 0 and 1 into True or False (1's and 0's)

fprintf('The number of heads in our simulation of %d tosses is : %d.\n', n, sum(tosses)) % print number of heads

% Number of recursive iterations
for i = 1:n,
    
    % Likelihood function, defined between 0 and 1, takes 0 elsewhere
    if tosses(i) == 1 % if heads
        like = unifpdf(x, 0, 1).*x; % then y(x) = x (linear likelihood)
    else % else if tails
        like = unifpdf(x, 0, 1).*(1 - x); % then y(x) = 1-x (linear likelihood)
    end
    
    plotLike = plot(x,like); % Plot 3: sample distribution
    leg = legend('prior', 'likelihood');
    
    % Compute the posterior by multiplying the likelihood by the prior
    % (pointwise multiplication because prior and like are both vectors of 1000
    % values, same as x)
    posterior = like.*prior;
    
    % Posterior needs to be normalized (i.e area under its curve needs to
    % be 1 which is equivalent to saying that the sum of all probabilities of
    % this distribution is equal to 1)
    area = trapz(x, posterior); 
    posterior = posterior/area;
    
    plotPost = plot(x, posterior, 'r'); % Plot 3: product distribution
    leg = legend('prior', 'likelihood', 'posterior');
    
    if(i < n),
    
        pause(1);

        delete(get(leg, 'Children'));

        delete(plotPrior);
        delete(plotLike);
        delete(plotPost);

        prior = posterior; % Plot 3: product distribution 

        plotPrior = plot(x,prior,'k'); % Plot 1: prior distribution
        leg = legend('prior');
    end;
end;

[a, idmax] = max(posterior);
fprintf("The estimated probability of heads p, given by the mean of the final Posterior distribution is : %.2f %%. \n", x(idmax)*100)
