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
X = X(:,1:4)'; % X in proper format now.

pS = sum (Y)/size(Y,1);     % all rows with Y = 1 
pE = sum(1 - Y)/size(Y,1);  % all rows with Y = 0

phiS = X * Y / sum(Y);  % all instances for which attrib phi(i) and Y are both 1
                        % P (X/Y=1)
              
phiE = X * (1-Y) / sum(1-Y) ;  % all instances for which attrib phi(i) = 1 and Y = 0
                               % P(X/Y=0)
                       
x=[1 0 1 0]';  % test point 
              
% Bernoulli distribution: f = (p^k)((1-p)^(1-k))
% Remember our x here is a vector of binary values, so that 
% phiS.^x.*(1-phiS).^(1-x) below will yeild a vector with each element being 
% a probability. 
% Then prod can be used to multiply all the values in x, as follows: 
% Given the class label, what is the probability of finding the attribute values?
pxS = prod(phiS.^x.*(1-phiS).^(1-x));
pxE = prod(phiE.^x.*(1-phiE).^(1-x));
% Given the attribute values, what is the probability of finding the class labels?
pxSF = (pxS * pS ) / (pxS * pS + pxE * pE) %P(Y=1|X)
pxEF = (pxE * pE ) / (pxS * pS + pxE * pE) %P(Y=0|X) 
