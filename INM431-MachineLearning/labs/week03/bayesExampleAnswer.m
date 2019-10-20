%% Bayesian Inference challenge - uniformly distributed initial prior, linear likelihood function
%% Thanks to Peter Simon for sharing his code 

%% Initialize environment

clear all; clc; close all;

trials = 100; % set number of iterations (see "iterate" below)
count_heads = 0; % let's count how many times we get heads...
count_tails = 0; % ...and tails

%% Initialize x vector, plot

x = linspace(0,1,1000); % x = 1000 points equally spaced in [0,1] interval
figure; hold on; 

% set axis limits
xlim([0 1]); ylim auto;



%% Initial prior distribution 

% replace old code for prior distribution with:
prior = 1 + 0*x;  
% gives 1 for each value of x, i.e. a uniform distribution 
% Try replacing with Beta distribution next!

plotPrior = plot(x,prior,'k'); % Plot 1: prior distribution
leg = legend('prior');


%% Iterate: posterior := prior x likelihood

for i = 1:trials
    
    % Determine likelihood function
    
    % let's toss the coin first. 1 = heads, 0 = tails.  
    coin = round(rand); 
    % rounding a number chosen randomly in the range [0,1]
    % How would you make this a biased coin?
    
    % let's set the likelihood function according to the coin toss
    if coin == 1 % heads
        count_heads = count_heads + 1;
        like = x; % assigns to "like" the same values of x, i.e. (x,like)=(0,0),...,(1,1) 
    else
        count_tails = count_tails + 1;
        like = 1 - x; % assigns to "like" the value 1-x, i.e. (x,like)=(0,1),...,(1,0)
    end
    
    % plot proportion of measured heads...
    plotSample = plot(count_heads/(count_heads+count_tails), 0, 'bx', 'MarkerSize', 16); 
    leg = legend('prior', 'measurement');
    
    % ...and the likelihood function
    plotLike = plot(x,like); 
    leg = legend('prior', 'measurement', 'likelihood');

    % determine the posterior distribution by pointwise multiplication
    unscaled_posterior = prior .* like;
        
    % Differently from Gaussian functions, unscaled_posterior needs to
    % be nornalized, e.g. by dividing unscaled_posterior by the area 
    % under the curve:
    uns_post_area = trapz(unscaled_posterior)/1000;
    posterior = unscaled_posterior / uns_post_area;
    % check value of post_area below to see why trapz above needs to be
    % divided by 1000
    
    % Consider, as an alternative to the above, rescaling the y-axis 
    % as follows:
    % range = max(unscaled_posterior) - min(unscaled_posterior);
    % posterior = (unscaled_posterior - min(unscaled_posterior)) / range;  
    
    % The above will look good, but check whether the area under the 
    % scaled posterior is equal to 1:
    post_area = trapz(posterior);
    
    % plot the posterior
    plotPost = plot(x, posterior, 'r'); 
    leg = legend('prior', 'measurement', 'likelihood', 'posterior');
    
    % get ready for next iteration 
    if(i < trials)
        
        % hold up, wait a second
        pause(0.1)
        
        % clean out the plot
        delete(get(leg, 'Children'));
        
        delete(plotPrior);
        delete(plotLike);
        delete(plotPost);
        delete(plotSample);
        
        % posterior becomes the new prior
        prior = posterior; 
        
        % plot the new prior
        plotPrior = plot(x,prior,'k'); 
        leg = legend('prior');
        
    end;
end;

% tidy up
delete(plotPrior);
delete(plotLike);

% output number of heads and tails to finish
count_heads
count_tails
