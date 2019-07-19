% close all windows, clear all variables, clear command prompt
close all; clear all; clc;

[folder, name, ext] = fileparts(which('nnTrain'));
cd(folder);

% Adding necessary files to the java path
javaaddpath([folder '\weka.jar']);
javaaddpath([folder '\SMOTE.jar']);

% Preparing the data
% Open file promoter.csv, start reading rows and columns with no offset
% (0,0) i.e. no column headers or row labels
file = 'promoter';
X = csvread([file '.csv'], 0, 0);
% size(X) returns size of array X
% 106   229
% i.e. 106 rows and 229 columns, which could also be expressed as
% size(X, 1) - number of rows (dim 1) in array X
% size(X, 2) - number of columns (dim 2) in array X
% The expression X(:,size(X,2)) says; w.r.t. array X, give me rows from 
% the first till the last, this is the colon on left of comma, for column
% indexed by size(X,2) ~ 229, or X(1:106,229)
% We could also say X(1:1,size(X,2)) to get the first row of the last
% column or X(1:2,1:2) to get the first two rows of the first two columns
t = X(:,size(X,2));
% Next we assign empty array [] to the last column which is to remove last
% column. Remember number of columns is 229
X(:,size(X,2)) = [];
% Now size(X,2)is 228, So we have an input vector X, with 116 rows and 228
% columns, and a target vector t with 116 rows and 1 column.
% size(t)  106     1 , size(X) 106   228
Type = 'scaling';
% make copy to compare methods
X1 = X;
%This function normalizes each column of an array  using the standard score or feature scaling.
X = StatisticalNormaliz(X,Type);
% Compare standard normalisation - subtract mean, divide by std i.e. zero
% centered
Type = 'standard';
X1 = StatisticalNormaliz(X1,Type);
% this seems to be doing the same as zero centering
X = (X * 2) - 1; 
% check if that is the case
compare = isequal(X, X1); % No, and in this case in would not make sense to use
% mean divided by standard deviation because values are not continuous
% NB We are transposing the matrix, and later we will see
% [numAttr,numExamples] = size(X); 
% Had the matrix not been transposed, size would return number of rows
% (examples) and number of columns (attributes).
X = X';

E = 1; % what is E? Does not seem to be doing anything in this code
originalInputSize = size(X,2);
classes = [1 -1];

% Get generator
st = rand('state');
% st = rng; % syntax above is deprecated, this line contains recommended replacement
% which is a struct, not and array, so probably needs extra plumbing
% Network Init
K = 2; % Number of Layers
etaInit = 0.01; % Learning Rate Initial Value
Delta = 0.1; % Stop Criterion #1
theta = 0.01; % Stop Criterion #2
numUpdates = 10000; % Max number of epochs
N = size(X,2); % Number of Input Vectors - NB dimension 2 because matrix is transposed
h = 11; % Number of Hidden Neurons
alpha = 0.999; % Learning Rate Decay Factor
mu = 0.1; % Momentum constant;
M = 10; % Number of Folds (N = leave-one-out)
shuffle = 1; % Shuffle control (turn it off for reproductibility)
smote = 0; % SMOTE oversampling

if(smote),
    smoteStr = 'yes';
else
    smoteStr = 'no';
end;
    
fprintf('----------------------------\n');
fprintf('- Neural Networks Training -\n');
fprintf('----------------------------\n\n');

fprintf('Dataset: %s\n', file);

% Setting SMOTE up
oldInputSize = N;
if(smote),
    % concatenate matrix X with t transpose (X has been transposed
    % previously) then transpose back - did X need transposing in the first
    % place?
    data = [X ; t']';

    data2arff(data, file);

    filter = javaObjectEDT('weka.filters.supervised.instance.SMOTE');

    fileReader = javaObjectEDT('java.io.FileReader',[file '.arff']);
    buffReader = javaObjectEDT('java.io.BufferedReader', fileReader);
    arffReader = javaObjectEDT('weka.core.converters.ArffLoader$ArffReader', buffReader);
                
    instances = arffReader.getData();
    instances.setClassIndex(size(data, 2)-1);

    paramFilter = java.lang.String('-C 0 -K 5 -P 100.0 -S 123');
    paramFilter = paramFilter.split(' ');

    filter.setOptions(paramFilter);
    filter.setInputFormat(instances);
    result = filter.useFilter(instances, filter);

    filteredData = zeros(result.numAttributes(),result.numInstances());
    for i = 1:result.numAttributes(),
        filteredData(i,:) = result.attributeToDoubleArray(i-1);
    end;

    t = (filteredData(size(filteredData, 1),:)*2)-1;
    X = filteredData;
    X(size(filteredData, 1),:) = [];
    
    if(M == N),
        N = size(X,2); 
        M = N;
    else
        N = size(X,2);
    end;  
end;

fprintf('Training type: %d folds on %d examples\n', M, oldInputSize);
fprintf('Data balancing? %s\n\n', smoteStr);

[numAttr,numExamples] = size(X);

% Shuffling data
if (shuffle),
    % Concatenate X(transpose), t transpose and a row of random numbers,
    % then transpose
    X = [X ; t' ; randn(1,numExamples)]';
    % sort by row (now column) or random numbers, then transpose back
    X = sortrows(X,numAttr+2)';
    % get target and example vectors
    t = X(numAttr+1,:); % from row number = numAttr+1 (last row), get all columns
    X = X(1:numAttr,:); % from row number 1 to row number = numAttr, get all columns
    % we now have two 
end;

% M-fold cross validation
% Create two 10x10 matrices
answer = zeros(M, floor(N/M));
target = zeros(M, floor(N/M));
% Create 5 1x10 vectors
tp = zeros(1, M);
fp = zeros(1, M);
tn = zeros(1, M);
fn = zeros(1, M);
acc = zeros(1, M);

avgAcc = 0;
% for 1 t0 10
for m = 1:M, % M = number of folds
    
    if(smote && m <= oldInputSize),
        fprintf('Training fold %d/%d...\n', m, oldInputSize);
    else
        if(m <= oldInputSize),
            fprintf('Training fold %d/%d...\n', m, M);
        end;
    end;
    
    % Layers initialization - for multi-class learning, this should be
    % changed
    % Note this is a matlab struct
    % rand(h,numAttr) - return a h (10) x numAttr (228) matrix of 
    % uniformly distributed random number in the interval (0,1)
    % (rand(h,1)-0.5)*0.2 - center at 0 (mean) and scale by 1/5, making
    % value range -0.1 0.1
    % Layer 1 weights will be a 11 (hidden neurons) rows by 228 (attributes) columns matrix
    L(1).W = (rand(h,numAttr)-0.5)*0.2;
    % Layer 1 biases will be a 11 (hidden neurons) rows by 1 column matrix
    L(1).b = (rand(h,1)-0.5)*0.2; 
    % Layer 2 weights will be 1 x 11 (hidden neurons) columns matrix
    L(2).W = (rand(1,h)-0.5)*0.2;
    % Layer 2 bias is a 1 x 1 zero centered, -0.1 0.1 scaled value
    L(2).b = (rand(1,1)-0.5)*0.2;

    % Add zero value matrices to our L (layer) struct, with the same
    % dimension as the corresponding initialised weight and bias matrices,
    % for layers one and two (K = 2)
    for k = 1:K, % K = Number of Layers
        L(k).vb = zeros(size(L(k).b));
        L(k).vW = zeros(size(L(k).W));
    end;

    % Sequential Error Backpropagation Training
    % n = counter to count up to number of examples, eta = learning rate
    n = 1; i = 1; finish = 0; eta = etaInit;
    % what are round and A?
    round = 1; A(m,round) = 0; % m = learning loop counter
    while not(finish),
        
        % Checking if it is a fold example
        ignoreTraining = 0; ignoreTesting = 0; % NB ignoreTraining means just that, do not train on this example
        % n with count up to N + 1 ~ 107 (106 examples + 1), then it will
        % reset to 1
        if ((n > ((m-1)*floor(N/M))) && (n <= (m*floor(N/M)))), 
        % when m  = 0, first expression evaluates to true (n > 0)
        % second expression evaluates to 
           ignoreTraining = 1;
           if((n > N) && ~shuffle),
               ignoreTesting = 1;
               break;
            end;
        end;
        
        J(m, i) = 0;
        if(~ignoreTraining), % if ignoreTraining == false, reset weights and biases
            for(k = 1:K),
                L(k).db = zeros(size(L(k).b));
                L(k).dW = zeros(size(L(k).W));
            end;
        end;

        for(ep = n:(n+E-1)), % E = 1, constant, this is to say, go around this for loop once 
            
            if((ep > N) || ignoreTraining), % ep > N will never be true? n is incremented past this point, and immediately checked if > N,
                                            % and set to one if it is > N.
                                            % TODO CHECK with breakpoint NB
                                            % ignoreTraining will be true
                                            % at times
                break;
            end;
            
            % Feed-Forward         
            L(1).x = X(:,ep);
            for k = 1:K,
                L(k).u = L(k).W * L(k).x + L(k).b;
                L(k).o = tanh(L(k).u);
                L(k+1).x = L(k).o;
            end; 
            e = t(n) - L(K).o;
            J(m,i) = J(m,i) + (e'*e)/2;

            % Error Backpropagation
            L(K+1).alpha = e; 
            L(K+1).W = eye(length(e));
            for k = fliplr(1:K),
                L(k).M = eye(length(L(k).o)) - diag(L(k).o)^2;
                L(k).alpha = L(k).M*L(k+1).W'*L(k+1).alpha;
                L(k).db = L(k).db + L(k).alpha;
                L(k).dW = L(k).dW + kron(L(k).x',L(k).alpha);
            end;
        end;

        % Updates
        for k = 1:K,
            if(ignoreTraining), 
                break; 
            end;
            L(k).vb = eta*L(k).db + mu*L(k).vb;
            L(k).b = L(k).b + L(k).vb;
            L(k).vW = eta*L(k).dW + mu*L(k).vW;
            L(k).W = L(k).W + L(k).vW;
        end;

        if(~ignoreTraining),
            A(m,round) = A(m,round) + (J(m, i)/(N-1));
            J(m, i) = J(m, i)/E; % E = 1, constant
        end;
            
        % Stop criterion
        if ((i > 1) && (n == N)),
            if (((A(m,round) < Delta) && ((round > 2) && (abs(A(m,round-2)-A(m,round-1) < theta) && (abs(A(m,round-1)-A(m,round)) < theta)))) || (i > numUpdates)),
                finish = 1;
            end;
        end;
        if not(finish)
            i = i+1; n = n+1; 
            if n > N, 
                n = 1;
                round = round + 1;
                A(m,round) = 0;
            end; 
            eta = eta*alpha;
        end;

    end;

    % Test
    % fprintf('Testing fold %d/%d...\n', m, M);
    
    if(~ignoreTesting),
        index = 0;
        for n = ((m-1)*floor(N/M))+1:m*floor(N/M),      
            index = index + 1;
            L(1).x = X(:,n);
            for k = 1:K,
                L(k).u = L(k).W*L(k).x + L(k).b;
                L(k).o = tanh(L(k).u);
                L(k+1).x = L(k).o;
            end;
            answer(m,index) = L(K).o;
            target(m,index) = t(n);

            if abs(answer(m,index) - target(m,index)) < (abs(classes(2) - classes(1))/2),
                if(abs(answer(m,index)-classes(1)) < abs(answer(m,index)-classes(2))), %TP case
                    tp(m) = tp(m) + 1; %TP case
                else                     
                    tn(m) = tn(m) + 1; %TN case
                end;
            else
                if(answer(m,index) > 0), %FP case
                    fp(m) = fp(m) + 1;
                else                     %FN case
                    fn(m) = fn(m) + 1;
                end;
            end;
        end;
    end;
        
    acc(m) = acc(m) + ((tp(m) + tn(m))/(tp(m) + tn(m) + fp(m) + fn(m)));
    avgAcc = avgAcc + (acc(m)/M);

end;

fprintf('Average accuracy: %f\n\n', avgAcc);
    
