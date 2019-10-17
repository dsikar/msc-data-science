clear; clc;

X = [ 0 0 1 1 0 ;
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

% class priors - Lecture 2 - pg 5 
% A class prior may be calculated by assuming equiprobable classes: prior = 1 / (number of classes), 
% or by calculating an estimate for the class probability from the training set: 
% class prior = (number of samples in the class) / (total number of samples)
% two priors, S and E
pS = sum (Y)/size(Y,1);     % all rows with Y = 1 - probability of Scottish
pE = sum(1 - Y)/size(Y,1);  % all rows with Y = 0 - probability of English

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

% So basically we sum the products of all the elements,
% to better visualise, we transpose Y:

% X(1,:)  0     1     1     1     0     0     1     1     1     1     1     1     1
% Y(:,1)' 0     0     0     0     0     0     1     1     1     1     1     1     1
% X(1,:)*Y(:,1) = 7

% X(2,:)  0     0     1     1     1     0     0     1     1     1     1     0     0
% Y(:,1)' 0     0     0     0     0     0     1     1     1     1     1     1     1
% X(2,:)*Y(:,1) = 4

% etc...

% X(1,:)*(1-Y)
% X(1,:)  0     1     1     1     0     0     1     1     1     1     1     1     1
% (1-Y)' 1     1     1     1     1     1     0     0     0     0     0     0     0
% X(1,:)*(1-Y) = 3

% etc...
% STOPPED HERE - what is phiS???
s
phiS = X * Y / sum(Y);  % all instances for which attrib phi(i) and Y are both 1
                        % P (X/Y=1)
% mu parameter              
phiE = X * (1-Y) / sum(1-Y) ;  % all instances for which attrib phi(i) = 1 and Y = 0
                               % P(X/Y=0)
% test point 
x=[1 0 1 0]';  % test point - porridge yes, lager no, watches england yes, etc
              
% Bernoulli distribution: f = (p^k)((1-p)^(1-k))
% Remember our x here is a vector of binary values, so that 
% phiS.^x.*(1-phiS).^(1-x) below will yeild a vector with each element being 
% a probability. 
% Then prod can be used to multiply all the values in x, as follows: 
pxS = prod(phiS.^x.*(1-phiS).^(1-x));
%    phiS       x   phiS.^x     1-phiS  1-x (1-phiS).^(1-x) phiS.^x.*(1-phiS).^(1-x)     
%    1.0000     1   1.0000      0       0   1.0000          1.0000
%    0.5714     0   1.0000      0.4286  1   0.4286          0.4286
%    0.7143     1   0.7143      0.2857  0   1.0000          0.7143
%    0.4286     0   1.0000      0.5714  1   0.5714          0.5714
% prod(phiS.^x.*(1-phiS).^(1-x)) = 1 * 0.4286 * 0.7143 * 0.5714 = 0.1749 
pxE = prod(phiE.^x.*(1-phiE).^(1-x)); % doc prod - Product of array elements
% Bayesian formula
% p(S, x) = p(x|S)*p(S)/p(x|S)*p(S) + p(x|E)*p(E)
pxSF = (pxS * pS ) / (pxS * pS + pxE * pE) %P(Y=1|X) 
% p(E, x) = p(x|E)*p(E)/p(x|E)*p(E) + p(x|S)*p(S)
pxEF = (pxE * pE ) / (pxS * pS + pxE * pE) %P(Y=0|X) 
