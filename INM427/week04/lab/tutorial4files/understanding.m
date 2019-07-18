close all;
clear all;
clc;

% Understanding matrix normalization

X = [1 1 1; 2 2 2; 3 3 3];

% X =

%     1     1     1
%     2     2     2
%     3     3     3

%Number of observations (rows)
N=size(X,1);

%Number of variables/attributes (columns)
M=size(X,2);

Y=zeros(N,M);

% Y =

%     0     0     0
%     0     0     0
%     0     0     0

%              _ _           
%  ___ __ __ _| (_)_ _  __ _ 
% (_-</ _/ _` | | | ' \/ _` |
% /__/\__\__,_|_|_|_||_\__, |
%                      |___/ 

% feature scaling

Max=max(X);

% Max =

%     3     3     3

Min=min(X);
 
% Min =

%    1     1     1

Difference=Max-Min;
 
% Difference =

%     2     2     2 

Y=X-repmat(Min,N,1); % repmat(Min,N,1) - repeat copies of array Min [1 1 1] in N(3) rows and 1 column

% Y =

%     0     0     0
%     1     1     1
%     2     2     2

Y=Y./repmat(Difference,N,1);

% ans =

%         0         0         0
%    0.5000    0.5000    0.5000
%    1.0000    1.0000    1.0000

%     _                _             _ 
%  __| |_ __ _ _ _  __| |__ _ _ _ __| |
% (_-<  _/ _` | ' \/ _` / _` | '_/ _` |
% /__/\__\__,_|_||_\__,_\__,_|_| \__,_|

% standard score

X = [1 1 1; 2 2 2; 3 3 3];

% X =

%     1     1     1
%     2     2     2
%     3     3     3

%Number of observations (rows)
N=size(X,1);

%Number of variables/attributes (columns)
M=size(X,2);

Y=zeros(N,M);

% Y =

%     0     0     0
%     0     0     0
%     0     0     0

%Subtract mean of each Column from data
Y=X-repmat(mean(X),N,1); % If A is a matrix, then mean(A) returns a row vector containing the mean of each column.

% mean(X)
%ans =

%     2     2     2

% repmat(mean(X),N,1) ~ repeat matrix X, N (3) times down (rows) and 1 time
% across (columns)

%ans =

%     2     2     2
%     2     2     2
%     2     2     2

% then subtract from X and assign to Y

% Y =

%    -1    -1    -1
%     0     0     0
%     1     1     1

%normalize each observation by the standard deviation of that variable
Y=Y./repmat(std(X,0,1),N,1); % std(A,0,1) returns a row vector containing the standard deviation of the elements in each column.
                             % std(A,0,2) returns a column vector containing the standard deviation of the elements in each row.
% std(X,0,1) ~ get the standard deviation along each column
% repmat(std(X,0,1),N,1) ~ repeat 3 times down and 1 time across

% ans =

%     1     1     1
%     1     1     1
%     1     1     1

% Divide matrix Y by standard deviation matrix

% Y =

%    -1    -1    -1
%     0     0     0
%     1     1     1


% Adding noise

% Given MxN training data matrix X where last column are targets

% X = [X ; t' ; randn(1,numExamples)]';

close all;
clear all;
clc;

% training data; examples x attributes
X = repmat([1 2 3 4 3 2 1 16], 6, 1);
% target - last column
t = X(:,size(X,2));
% training data minus target column
X(:,size(X,2)) = [];
% store magnitudes 
[numExamples, numAttr] = size(X);
% transpose X
X = X';
% concatenate and transpose
X = [X ; t' ; randn(1,numExamples)]'; % randn(1,numExamples) - row of random numbers

X = sortrows(X,numAttr+2)'; % need to transpose to sort by (random number) row 
% note we exclude the random numbers with index numAttr+1, where random
% number index is numAttr+2
t = X(numAttr+1,:); % from row number = numAttr+1 (last row), get all columns
X = X(1:numAttr,:); % from row number 1 to row number = numAttr, get all columns

