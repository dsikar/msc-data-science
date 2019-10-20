% Gaussian Naive Bayes
% Tim Laibacher
% clear workspace
clc;clear 
% Data
xM=[6 5.92 5.58 5.92; % male attributes
    180 190 170 165;
    12 11 12 10;]
xF=[5 5.5 5.42 5.75;  % fremale attributes
    100 150 130 150;
    6 8 7 9;]
% Prios for female and male are the means (maximum likelihood solution in
% for Guassian distribution)
% size(matrix,2) 2 indicates the dimension, in this case column
pM = size(xM,2)/(size(xM,2) + size(xF,2));
pF = size(xF,2)/(size(xF,2) + size(xM,2));

% Likelihood parameters for the three Gaussian liklihood functions
% mean (mu) and standard deviation (=variance^2) for each attribute
meansM = mean(xM')';
meansF = mean(xF')';
stdsM = std(xM')';
stdsF = std(xF')';

% Posterior for two test points xt 
%xt = [6 130 8]'; % second test is commented out
xt = [5.6 167 9;]';

% calculate likelihood 
% parameter of n changes probablities, which value is appropriate?
% no details provided in sample answer
n = 0.1
aM = cdf('Normal',xt+n,meansM,stdsM);
bM = cdf('Normal',xt-n,meansM,stdsM);
areaM = aM -bM;
aF = cdf('Normal',xt+n,meansF,stdsF);
bF = cdf('Normal',xt-n,meansF,stdsF);
areaF = aF - bF; 

pxtM = pM*prod(areaM); % P(xt,M)
pxtF = pF*prod(areaF); % P(xt,F)

pMxt = pxtM/(pxtM+pxtF) % P(M|xt) probability that xt is female 
pFxt = pxtF/(pxtF+pxtM) % P(F|xt) probability that xt is male

% Applying MAP (a.k.a. argmax):
if pMxt > pFxt
    gender = 'male'
else
    gender = 'female'
end

% Additional notes
% We can use a shortcut by just using normpdf to produce density values
% from the Gaussian and use them directly with MAP decision rule (argmax)
% but note that these are not probablities!
ProdDensM=prod(normpdf(xt,meansM,stdsM));
ProdDensF=prod(normpdf(xt,meansF,stdsF));
% below densities are the same as in wikipedia
% https://en.wikipedia.org/wiki/Naive_Bayes_classifier
densisM = normpdf(xt,meansM,stdsM);
densisF = normpdf(xt,meansF,stdsF);
    
    