clear all; clc; close all;

% Example of Bayesian Inference on 2 normal distributions
% Give me 1000 linearly spaced numbers between 0 and 10
x = linspace(0,10,1000); % doc linspace - Generate linearly spaced vector, 
% linspace(x1,x2,n) generates n points. The spacing between the points is (x2-x1)/(n-1). 
% so x looks like [[0,0.0100,0.0200,0.0300,0.0400 ... 9.9800,9.9900,10.0000]

%x = ones(1,1000,1);
% set the properties of the plot we are going to generate
% Keep it on, set x from 0 to ten, set y from 0 to 1
figure; hold on; axis([0 10 0 1]);

% Prior distribution - replace distribution to uniformly distributed prior
% set the "prior" mean to 5, which makes sense, given our data
pm = 5; % Prior mean
% A small variance would lead to a "higher" bump, a large variance, to a
% lower bump.
% Set variance equal to 4, meaning, most of the values lie within 2 units
% plus or minus the mean
ps2 = 4; % Prior variance, "prior sigma squared" - variance is sigma (standard deviation) squared, stardard deviation is square root of variance
% Slide 3, lecture 2
% prior = (2*pi*ps2)^(-0.5)*exp(-0.5*(x-pm).^2/ps2); % TASK Change prior so we get one for each data point
% stopped here, investigating .^2/ps2s
% This looks like a Gaussian function
% Set the prior, what this function does:
% 1. go through every value of x matrix in turn
% 2. for every value, compute the likelihood, that is to say, given a mean
% of 5 and a variance of 4, what is the likelihood of that number in the
% distribution.
% Now this might sound a bit weird, the numbers are evenly spaced out, from
% zero to ten, yet,
% the prior plot is going to look normally distributed?
% Let's put things in perspective; the prior here is an arbitrary function
% of x (our evenly spaced matrix) and it has been defined as prior = (2*pi*ps2)^(-0.5)*exp(-0.5*(x-pm).^2/ps2)
% What this function does is, given a prior mean (pm), a prior variance
% (ps2 - s2 for "sigma squared", sigma being the square root of variance
% a.k.a. standard deviation) and some x value or values, tell me what is
% the likelihood of that value of x. 
% So if we given that function a value of x equal to 1, a mean equal to 7 and a variance equal to 4, we will not
% expect to see the number 1 a lot in that case, so the likelihood of
% seeing 1 is expected to be quite small, or as some authors (i.e. Bishop)
% say, the expectation of x in this case would be low. If we run this:
% x = 1; pm = 7; ps2 = 4; (2*pi*ps2)^(-0.5)*exp(-0.5*(x-pm).^2/ps2)
% we get 0.0022
% Is we make x = 6.5, that is a lot closer to the mean in our "expectation"
% function, what that is saying is, we are expecting to see 6.5 more than
% we are expecting to see 1. Let's try it:
% x = 6.5; pm = 7; ps2 = 4; (2*pi*ps2)^(-0.5)*exp(-0.5*(x-pm).^2/ps2)
% we get 0.1933, so the "likelihood" of observing 6.5 is 0.1933, or 19%,
% while the "likehood" of observing 1 is 0.0022, or 0.2%, according to our
% prior distribution function. Now, let's suppose we decrease the variance, and set ps2 = 2.
% Something like this:
% x = 1; pm = 7; ps2 = 2; (2*pi*ps2)^(-0.5)*exp(-0.5*(x-pm).^2/ps2)
% 3.4813e-05 ~ 0.000034813
% x = 6.5; pm = 7; ps2 = 2; (2*pi*ps2)^(-0.5)*exp(-0.5*(x-pm).^2/ps2)
% 0.2650
% With the new variance, the expectation function says that we expect to
% see 6.5 even more often, while the expectation of observing a value of x
% = 1 has decreased to a very small number, we would expect to observe it 3
% times for every 100k samples, or 0.003%
prior = (2*pi*ps2)^(-0.5)*exp(-0.5*(x-pm).^2/ps2); % ".^" - matlab elementwise matrix power 
% prior now is an array of values, with the likelihood of observing values
% in x, prior looks like this:
% prior(1,1:5) % show first 5 columns of prior likehood matrix, basically
% the y axis of our plot
% 0.0088    0.0089    0.0090    0.0091    0.0092
% Plot the prior based on original prior function, with median = 5 and
% standard deviation = 5
plotPrior = plot(x,prior,'k'); % Plot 1: prior distribution
leg = legend('prior');

lm = 6; % sample mean
ls2 = 3; % sample variance, 
% Once inside the loop, this will become our "prior", or likelihood
% function, with mean 6 and variance = 3
like = (2*pi*ls2)^(-0.5)*exp(-0.5*(x-lm).^2/ls2);
% Number of recursive iterations
for i = 1:10,
    % Likelihood function 
    % NB lm, ls2 and like do not change, so no need to run assignments in
    % this loop, running outside loop
    % lm = 6; % sample mean
    % ls2 = 3; % sample variance, 
    % we plot a marker "x" for the mean on the x axis, this will be 6.
    plotSample = plot(lm, 0, 'bx', 'MarkerSize', 16); % Plot 2: sample mean
    leg = legend('prior', 'measurement');
    % TASK 2 - change this to linearly distributed posterior
    % like = (2*pi*ls2)^(-0.5)*exp(-0.5*(x-lm).^2/ls2);
    % like = x1; %(2*pi*ls2)^(-0.5)*exp(-0.5*(x-lm).^2/ls2);
    % matlab pointwise 
    % We now plot the x values, with the corresponding like values
    plotLike = plot(x,like); % Plot 3: sample distribution
    % Note this likelihood function has a mean of 6 and variance of 3, the
    % like matrix looks like this:
    % like(1,1:5) % show first 5 columns of "like" likehood matrix
    % 1.0e-03 *
    %    0.5709    0.5825    0.5942    0.6062    0.6184
    % Comparing "prior" and "like" matrices, we see "like" has much smaller
    % values for likelihood, which we expect, given mean = 6 and variance =
    % 3, that is to say, if we look at the first 5 values of the x matrix:
    % x(1,1:5)
    % 0    0.0100    0.0200    0.0300    0.0400
    % the likelihood of seeing those values is low, given a mean of 6 and a
    % variance of 3, values such as 0.01 and 0.02 are very far from that
    % range
    leg = legend('prior', 'measurement (sample) mean', 'likelihood');
    % posterior
    % Now we are going to compute the posterior variance, Ps2 or "posterior
    % sigma squared in plane english, remember sigma is the symbol for
    % standard deviation, and sigma squared is the variance, or, standard
    % deviation is the square root of the variance.
    % This computation is also arbitrary, and is taken from:
    % https://ocw.mit.edu/courses/mathematics/18-05-introduction-to-probability-and-statistics-spring-2014/readings/MIT18_05S14_Reading15a.pdf
    % pg. 5
    % This assignment is changing the posterior variance, by a factor of (1/ps2 + 1/ls2)^(-1)
    % that is to say, the prior variance ps2 and the current variance ls2,
    % which in this example code, never changes.
    % if we actually look at the changing values of Ps2 we get:
    % create an empty 3 rows x 11 columns matrix to hold our posterior variance
    % values and calculations
    %post_vals = zeros(3, 11);
    % our prior and current variances as per example code
    %ps2 = 4; ls2 = 3;
    % store the first prior variance
    %post_vals(1, 1) = ps2;
    %for i = 1:10, 
    %    Ps2 = (1/ps2 + 1/ls2)^(-1);
        % save the new posterior variance
    %    post_vals(1, i+1) = Ps2;
        % save the change ratio new posterior variance/old posterior variance
    %    post_vals(2, i+1) = Ps2/ps2; 
        % save the difference old posterior variance - new posterior variance
    %    post_vals(3, i+1) = ps2 - Ps2;      
        % change prior variance
    %    ps2 = Ps2;
    %end;
    % Display the information
    %disp(post_vals)
    %    4.0000    1.7143    1.0909    0.8000    0.6316    0.5217    0.4444    0.3871    0.3429    0.3077    0.2791
    %         0    0.4286    0.6364    0.7333    0.7895    0.8261    0.8519    0.8710    0.8857    0.8974    0.9070
    %         0    2.2857    0.6234    0.2909    0.1684    0.1098    0.0773    0.0573    0.0442    0.0352    0.0286
    % What are these numbers telling us?
    % With every iteration in the for loop, the posterior variance is
    % decreasing, starting with a factor of 0.42 down to 0.90 in the last
    % iteration, so in the last iteration, the posterior variance will be equal
    % to 0.2791, being about 91% of the value of the prior variance, which
    % represents an absolute change, in this case, of approximately 0.0286.
    % That is what "Ps2 = (1/ps2 + 1/ls2)^(-1);" is doing, in plain english, every time you go through this loop,
    % decrease the variance. 
    % TODO check if we need to take the inverse of Ps2, as per 
    Ps2 = (1/ps2 + 1/ls2)^(-1); % Formulas not given in lecture notes
    % Alternatively; ps2 * ls2 / (ps2 + ls2) - which one is more
    % computationally efficient?
    % mean 
    % Now let's do the same thing with the mean, how is this value changing
    % in every iteration
    Pm = Ps2*(pm/ps2 + lm/ls2);
    % Lecture 2 page 3
    posterior = (2*pi*Ps2)^(-0.5)*exp(-0.5*(x-Pm).^2/Ps2);
    plotPost = plot(x, posterior, 'r'); % Plot 3: product distribution
    leg = legend('prior', 'measurement (sample) mean', 'likelihood', 'posterior');
    
    if(i < 10),
    
        pause(1);

        delete(get(leg, 'Children'));

        delete(plotPrior);
        delete(plotLike);
        delete(plotPost);
        delete(plotSample);

        prior = posterior; % Plot 3: product distribution 
        pm = Pm; % prior mean = posterior mean
        % display on console
        % disp(Pm)
        ps2 = Ps2; % prior variance = posterior variance
        % display on console
        % disp(ps2)
        plotPrior = plot(x,prior,'k'); % Plot 1: prior distribution
        leg = legend('prior');
    end;
end;
