clear; clc;
% shortbread, lager, porridge, watches england, scottish/english
X =   [ 0 0 1 1 0 ;
        1 0 1 0 0 ;
        1 1 0 1 0 ;
        1 1 0 0 0 ;
        0 1 0 1 0 ;
        0 0 1 0 0 ;
        1 0 1 1 1 ;
        1 1 0 1 1 ;
        1 1 1 0 1 ;
        1 1 1 0 1 ;
        1 1 1 1 1 ;
        1 0 1 0 1 ;
        1 0 0 0 1 ];

Y = X(:,5);
X = X(:,1:4)'; % X in proper format now. See ctranspose, ' - Complex conjugate transpos, 

% class priors - Lecture 3 - pg 5 
% A class prior may be calculated by assuming equiprobable classes: prior = 1 / (number of classes), 
% or by calculating an estimate for the class probability from the training set: 
% class prior = (number of samples in the class) / (total number of samples)
% two priors, S and E
pS = sum (Y)/size(Y,1);     % all rows with Y = 1 - probability of Scottish - 0.5385
pE = sum(1 - Y)/size(Y,1);  % all rows with Y = 0 - probability of English- 0.4615

% Lecture 2, pg 19 - same idea of max log likelihood
% mu parameter

% C = A*B is the matrix product of A and B. If A is an m-by-p and B is a p-by-n matrix, then C is an m-by-n matrix defined by
% C(i,j)= SUM A(i,k)B(k,j)
%         k=1
% This definition says that C(i,j) is the inner product of the ith row of A 
% with the jth column of B. You can write this definition using the MATLAB® colon operator as
% C(i,j) = A(i,:)*B(:,j)
% whos X
%  Name      Size            Bytes  Class     Attributes

%  X         4x13              416  double  
% whos Y
%  Name       Size            Bytes  Class     Attributes

%  Y         13x1               104  double 

% Result of X*Y will be a 4x1 vector

% For nonscalar A and B, the number of columns of A must equal the number
% of rows of B
% Example
% C(1,1) = X(1,:)*Y(:,1)
% X(1,:)

% ans =

%     0     1     1     1     0     0     1     1     1     1     1     1     1
% Y(:,1)

% ans =

%     0
%     0
%     0
%     0
%     0
%     0
%     1
%     1
%     1
%     1
%     1
%     1
%     1

% So basically we sum the products of all the elements of X times Y (Y=1) and 1-Y (Y=0),
% to better visualise, we transpose Y:

% X(1,:)  0     1     1     1     0     0     1     1     1     1     1     1     1
% Y(:,1)' 0     0     0     0     0     0     1     1     1     1     1     1     1

% X(1,:)*Y(:,1) = 7 - in plain english, sum of products of "likes shortbread" binary attribute by class label "scottish" is equal to 7
% i.e. 0*0 + 1*0 + 1*0 + 1*0 + 0*0 + 0*0 + 1*1 + 1*1 + 1*1 + 1*1 + 1*1 + 1*1 + 1*1 = 7 
% 
% X(2,:)  0     0     1     1     1     0     0     1     1     1     1     0     0
% Y(:,1)' 0     0     0     0     0     0     1     1     1     1     1     1     1

% X(2,:)*Y(:,1) = 4 - in plain english, sum of products of "eats porridge" binary attribute by class label "scottish" is equal to 4
% i.e. 0*0 + 0*0 + 1*0 + 1*0 + 1*0 + 0*0 + 0*1 + 1*1 + 1*1 + 1*1 + 1*1 + 0*1 + 0*1 = 4 

% etc...

% X(1,:)*(1-Y)
% X(1,:)  0     1     1     1     0     0     1     1     1     1     1     1     1
% (1-Y)'  1     1     1     1     1     1     0     0     0     0     0     0     0

% X(1,:)*(1-Y) = 3 - in plain english, sum of products of "likes shortbread" binary attribute by class label "english" is equal to 3

phiS = X * Y / sum(Y);  % all instances for which attrib phi(i) and Y are both 1
                        % P (X/Y=1)
% X * Y
%     7
%     4
%     5
%     3
% sum(Y) = 7
% X * Y / sum(Y)
%    1.0000
%    0.5714
%    0.7143
%    0.4286
% So "X * Y / sum(Y)" is the mean (mu) of the attribute value w.r.t. class label
% which is also the probability of X given Y (Y=1, in this case).

% mu parameter              
phiE = X * (1-Y) / sum(1-Y) ;  % all instances for which attrib phi(i) = 1 and Y = 0
                               % P(X/Y=0)
% X * (1-Y) / sum(1-Y)
%    0.5000
%    0.5000
%    0.5000
%    0.5000
    
% test point 
x=[1 0 1 0]';  % test point - shortbread yes, lager no, porridge yes, watches england no
              
% Bernoulli distribution: f = (p^k)((1-p)^(1-k)) - pg 19. In plain english,
% Product (over N) of the mean p to the power of k (x subscript n) by one minus the mean, to the power of one minus k (x subscript n) 

% Remember our x here is a vector of binary values, so that 
% phiS.^x.*(1-phiS).^(1-x) below will yield a vector with each element being 
% a probability. 
% Then prod can be used to multiply all the values in x, as follows: 
% Probability of observing test point vector, given class label scottish
pxS = prod(phiS.^x.*(1-phiS).^(1-x)); % NB exponentiation with order 4x1 base and exponent vectors
%    phiS       x   phiS.^x     1-phiS  1-x (1-phiS).^(1-x) phiS.^x.*(1-phiS).^(1-x)     
%    1.0000     1   1.0000      0       0   1.0000          1.0000
%    0.5714     0   1.0000      0.4286  1   0.4286          0.4286
%    0.7143     1   0.7143      0.2857  0   1.0000          0.7143
%    0.4286     0   1.0000      0.5714  1   0.5714          0.5714
% prod(phiS.^x.*(1-phiS).^(1-x)) = 1 * 0.4286 * 0.7143 * 0.5714 = 0.1749 
% pxS = 0.1749 
% probability of observing test point vector, given class label english
pxE = prod(phiE.^x.*(1-phiE).^(1-x)); % doc prod - Product of array elements
% Same again for pxE with some vector manipulation to save copy and paste
% mymtrx = phiE; mymtrx(:,2) = x; mymtrx(:,3) = phiE.^x; mymtrx(:,4) = 1-phiE; 
% mymtrx(:,5) = (1-x); mymtrx(:,6) = (1-phiE).^(1-x); mymtrx(:,7) = phiE.^x.*(1-phiE).^(1-x);
%  mymtrx
%    phiE      x         phiE.^x   1-phiE    1-x       (1-phiE).^(1-x)  phiE.^x.*(1-phiE).^(1-x)
%    0.5000    1.0000    0.5000    0.5000         0    1.0000           0.5000
%    0.5000         0    1.0000    0.5000    1.0000    0.5000           0.5000
%    0.5000    1.0000    0.5000    0.5000         0    1.0000           0.5000
%    0.5000         0    1.0000    0.5000    1.0000    0.5000           0.5000
% prod(phiE.^x.*(1-phiE).^(1-x)) = 0.5000 * 0.5000 * 0.5000 * 0.5000 = 0.0625
% pxE = 0.0625 

% Bayesian formula
% probability of observing class label scottish, given test point vector
% p(x|S) = p(x|S)*p(S)/p(x|S)*p(S) + p(x|E)*p(E)
pxSF = (pxS * pS ) / (pxS * pS + pxE * pE); %P(Y=1|X) 
% pxSF = 0.76555 
% probability of observing class label english, given test point vector
% p(E, x) = p(x|E)*p(E)/p(x|E)*p(E) + p(x|S)*p(S)
pxEF = (pxE * pE ) / (pxS * pS + pxE * pE); %P(Y=0|X) 
% psEF = 0.23445
% A loop to check out all possibilities

% for i = 0:15 % get all combinations
%     disp(dec2bin(i))
% end;

Z =[0 0 0 0;
    0 0 0 1;
    0 0 1 0;
    0 0 1 1;
    0 1 0 0;
    0 1 0 1;
    0 1 1 0;
    0 1 1 1;
    1 0 0 0;
    1 0 0 1;
    1 0 1 0;
    1 0 1 1;
    1 1 0 0;
    1 1 0 1;
    1 1 1 0;
    1 1 1 1];

for i = 1:16 
     x = Z(i,:)'; % transpose, so x. 1-x is 4x1 vector, like  
     pxS = prod(phiS.^x.*(1-phiS).^(1-x));
     pxE = prod(phiE.^x.*(1-phiE).^(1-x));
     pxSF = (pxS * pS ) / (pxS * pS + pxE * pE);
     pxEF = (pxE * pE ) / (pxS * pS + pxE * pE);
     % Reminder shortbread, lager, porridge, watches england
     disp("% Test point:")
     disp(Z(i,:))
     disp("% pxSF = " + string(pxSF) + ", psEF = " + string(pxEF))
end;

% Test point:
%     0     0     0     0 - nothing - english

% pxSF = 0, psEF = 1
% Test point:
%     0     0     0     1 - england - english

% pxSF = 0, psEF = 1
% Test point:
%     0     0     1     0 - porridge - english

% pxSF = 0, psEF = 1
% Test point:
%     0     0     1     1 - porridge, england - english

% pxSF = 0, psEF = 1
% Test point:
%     0     1     0     0 - lager - english

% pxSF = 0, psEF = 1
% Test point:
%     0     1     0     1 - lager, england - english

% pxSF = 0, psEF = 1
% Test point:
%     0     1     1     0 - lager, porridge - english

% pxSF = 0, psEF = 1
% Test point:
%     0     1     1     1 - lager, porridge, england - english 

% pxSF = 0, psEF = 1
% Test point:
%     1     0     0     0 - shortbread - scottish

% pxSF = 0.56637, psEF = 0.43363
% Test point:
%     1     0     0     1 - shortbread, england - english

% pxSF = 0.49485, psEF = 0.50515
% Test point:
%     1     0     1     0 - shortbread, porridge - scottish

% pxSF = 0.76555, psEF = 0.23445
% Test point:
%     1     0     1     1 - shortbread, porridge, england - scottish

% pxSF = 0.71006, psEF = 0.28994
% Test point:
%     1     1     0     0 - shortbread, lager - scottish

% pxSF = 0.63524, psEF = 0.36476
% Test point:
%     1     1     0     1 - shortbread, lager, england - scottish

% pxSF = 0.56637, psEF = 0.43363
% Test point:
%     1     1     1     0 - shortbread, lager, porridge - scottish

% pxSF = 0.81321, psEF = 0.18679
% Test point:
%     1     1     1     1 - shortbread, lager, porridge, england - scottish

% pxSF = 0.76555, psEF = 0.23445

% To try to cement the understanding, let's look at this apparently
% counterintuitive case, given 3/6 english and 5/7 scottish eat porridge:

% Test point:
%     0     0     1     0 - porridge - english

x=[0 0 1 0]'; % test point
% pxSF = 0, psEF = 1

pxS = prod(phiS.^x.*(1-phiS).^(1-x));
% mymtrx = phiS; mymtrx(:,2) = x; mymtrx(:,3) = phiS.^x; mymtrx(:,4) = 1-phiS; 
% mymtrx(:,5) = (1-x); mymtrx(:,6) = (1-phiS).^(1-x); mymtrx(:,7) = phiS.^x.*(1-phiS).^(1-x);
%                phiS           x    phiS.^x   1-phiS    1-x      (1-phiS).^(1-x)   phiS.^x.*(1-phiS).^(1-x)
% shortbread     1.0000         0    1.0000         0    1.0000    0                0                   	probability of scottish not liking shortbread    equivalent to 0/7 ~ 0
% lager          0.5714         0    1.0000    0.4286    1.0000    0.4286           0.4286                 	probability of scottish not liking lager         equivalent to 3/7 ~ 0.4286
% porridge       0.7143    1.0000    0.7143    0.2857         0    1.0000           0.7143                  probability of scottish liking porridge          equivalent to 5/7 ~ 0.7143
% england        0.4286    1.0000    0.4286    0.5714         0    1.0000           0.4286                  probability of scottish not watching england     equivalent to 3/7 ~ 0.4286
% Probability of finding [0 0 1 0] given scottish is equal to the product of probabilities 
% prod(0 * 0.4286 * 0.7143 * 0.4286) = 0
% pxS = 0
% Considering Bayes' Theorem: p(X|Y) = P(Y|X)*P(X)/P(Y), perhaps variable
% pxSF could have been called pSx
pxSF = (pxS * pS ) / (pxS * pS + pxE * pE);

% now let's do the same for english
pxE = prod(phiE.^x.*(1-phiE).^(1-x));
% mymtrx = phiE; mymtrx(:,2) = x; mymtrx(:,3) = phiE.^x; mymtrx(:,4) = 1-phiE; 
% mymtrx(:,5) = (1-x); mymtrx(:,6) = (1-phiE).^(1-x); mymtrx(:,7) = phiE.^x.*(1-phiE).^(1-x);

%                phiE           x    phiE.^x   1-phiS    1-x      (1-phiE).^(1-x)	phiE.^x.*(1-phiE).^(1-x)
% shortbread     0.5000         0    1.0000    0.5000    1.0000    0.5000    		0.5000			probability of english not liking shortbread	equivalent to 3/6 ~ 0.5
% lager          0.5000         0    1.0000    0.5000    1.0000    0.5000    		0.5000			probability of english not liking lager		equivalent to 3/6 ~ 0.5 
% porridge       0.5000    1.0000    0.5000    0.5000         0    1.0000    		0.5000			probability of english liking porridge		equivalent to 3/6 ~ 0.5
% england        0.5000         0    1.0000    0.5000    1.0000    0.5000    		0.5000			probability of english watching england		equivalent to 3/6 ~ 0.5
% prod(0.5 * 0.5 * 0.5 * 0.5) = 0.0625
pxEF = (pxE * pE) / (pxE * pE + pxS * pS)

% We see that because the probability scottish eats shortbread = 1, the probability of the test point given the
% class label scottish = 0 (all scottish eat shortbread), so the product of test point probabilities will also be = 0, and P(Y=1|X)
% will also be = 0.
% While class label english has probability of every attribute value = 0.5.

% We see that the Bernoulli distribution in this case is multipling two
% factors;
% 1. The mean of the attribute for a given class label, raised to the power of the attribute
% value in test point vector
% 2. One minus the mean of the attribute for a given class label, raised to
% the power of one minus the attribute value in test point vector.
% The result of this multiplication is such that,
% if the attribute value in
% test point vector is 1, result will be the mean of the attribute value
% for given class label, that is to say, the probability of the attribute
% value ocurring given the class label.
% If the attribute value in test point is 0, 

% If we think of the Bernoulli distribution in terms of a positive and a
% negative factor:
P(C|a)^x*P(C|~a)^~x
Where P(C|a) is the probability of observing the class given the attribute and
P(C|~a)
pxEF = (pxE * pE) / (pxE * pE + pxS * pS)

%selecting the class probabilities of the 
% attributes values in the test point vector. If the attribute value is equal to one, we are left with the value of the mean, as 1 - x will be the exponent 0, so 1 - mean raised to attribute value 
% zero will be equal to 1. In other words, if the attribute value is equal to zero, the class probability, raise to
% the attribute value will be equal to one, and one minus the class
% probability, raise to the power of 1 minus the attribute value, will be
% equal to the attribute probability of the class.
