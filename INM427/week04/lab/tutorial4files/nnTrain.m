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
        % reset to 1. When we n > 10, we will have counted through our 10
        % testing examples, and from the 11th onwards, we start training
        % the network
        if ((n > ((m-1)*floor(N/M))) && (n <= (m*floor(N/M)))), 
        % when m  = 0, first expression evaluates to true (n > 0)
        % second expression evaluates to 
           ignoreTraining = 1;
           if((n > N) && ~shuffle),
               ignoreTesting = 1; % NB we keep the last set of weights 
               break;
            end;
        end;
        
        J(m, i) = 0; % What is J? J is error vector
        if(~ignoreTraining), % if ignoreTraining == false, we are training, add delta bias and weight fields to struct
            for(k = 1:K),    % In layer 1 (hidden) we have 11 neurons, in layer 2 (output) we have 1 neuron
                L(k).db = zeros(size(L(k).b)); % So this will look like either a 11 row one column vector of of zeros
                L(k).dW = zeros(size(L(k).W)); % Or a one row, one column vector of zeros
            end;
        end;
        % ep assumed epoch. We are only going through this loop once
        for(ep = n:(n+E-1)), % E = 1, constant, this is to say, go around this for loop once, why is E used?
            
            if((ep > N) || ignoreTraining), % Basically what this says ep must be greater than 10 AND less or equal to 106 
                                            % examples (indexed 1 to 10 
                                            % and picked at random)
                                            % Otherwise, break
                                            %  
                                            %  
                break;
            end;
            
            % Feed-Forward         
            L(1).x = X(:,ep); % Assign 228 attributes to L(1).x
            for k = 1:K, % we get here at n = 11, i.e. first 10 examples where not used
                % Size of layer 1 weight matrix L(1).W is 11 rows x 228 cols, size of input matrix L(1).x is 228 rows x 1 col
                % size of layer 1 bias matrix L(1).b is 11 rows x 1 col, size of resulting input potential matrix 
                % L(1).u is 11 x 1
                % Matrix multiplication recap, for A * B, Number of A columns must match number of B rows, resulting matrix will be
                % of dimension A rows x B columns 
                L(k).u = L(k).W * L(k).x + L(k).b; % Calculate input potential, with weights and biases initialised previously
                % Note weights and inputs result in 11 x 1 matrix which can be added to bias matrix
                L(k).o = tanh(L(k).u); % activations, using the hyperbolic tangent function, notice is will be 11 x 1 also for hidden layer
                L(k+1).x = L(k).o; % inputs to next layer (k+1), are the activations of previous layer
            end; 
            e = t(n) - L(K).o; % we are indexing the layer we a variable that tells us how many layers the network has, good practice?
            J(m,i) = J(m,i) + (e'*e)/2; % mean square error, note transpose matrix multiplication - probably for more than one output node
            % Looks like we'll keep increaing the size of J columns as we go
            % Error Backpropagation
            % We are assigning error to a field in a struct (L(K+1).alpha) that will be
            % used as d ~ the gradient, which for the output neuron will be e (error) * tanh'(x) (derivative of activation function), 
            % stored in struct filed L(k).M, and for a hidden node will be d * W * tanh'(x)
            L(K+1).alpha = e; % error stored in .alpha field for convenience
            L(K+1).W = eye(length(e)); % create identity matrix the size of output layer
            for k = fliplr(1:K), % fliplr ~ flip array left to right, iterate starting from 2 then one i.e. decrement
                L(k).M = eye(length(L(k).o)) - diag(L(k).o)^2; % eye - identity matrix, diag - diagonal matrix - M is the derivative of hyperbolic tangent function
                % https://theclevermachine.wordpress.com/2014/09/08/derivation-derivatives-for-common-neural-network-activation-functions/
                % tanh'(x) = 1 - tanh^2(x) note this is the matrix matlab idiom, we need to perform the operation on values storeda column vector (11x1) L(k).o  
                % That is to say, for each value in L(k).o, square it and subtract it from one, however we can only square a square matrix, 
                % hence first transform activations L(k).o into a square matrix with diag(L(k).o) then square itit
                % then we need to subtract the values in diagonal from one, and we do that by creating another diagonal matrix with ones, of the same length
                % of the activation (outputs of previous layer) matrix, that is eye(length(L(k).o)), then we are good to subtract and obtain our derivative
                % function output, which are held in the resulting diagonal matrix, to compute slope db, error gradient alpha.
                % L(k).M = tanh'(x) , L(k+1).alpha = error (or slope d), M * alpha = slope , L(k+1).W = weight , slope * weight = error 
                L(k).alpha = L(k).M * L(k+1).W' * L(k+1).alpha; % This would probably be best understood in the context of multiple outputs
                %          = h'    * W       * error = di (slope, local grandient)
                % ej = Wkj . dok ~ L(k+1).W *  L(k+1).alpha 
                % dj = ej . h'(Uj) ~ ej = Wkj * dk, so if we represent  dj = h' * W * dk, then L(k).M*L(k+1).W'*L(k+1).alpha makes sense where L(k).alpha is 
                % equivalent to dj, as discussed in class. So in matlab, our h' is in a diagonal matrix L(k).M we multiply by the weights, which is a 1 x 11 matrix
                % To multiply vectors A*B, the number of A columns must be the same of number of B rows, and we end up with a matrix size A rows, B columns, so
                % we transpose L(k+1).W and then multiply by our h' matrix and end up with a 11 x 1 matrix, which we then multiply by the previous "alpha", which
                % for the output neuron was error * h'.
                % the .alpha field stores d, which we need to update weights and biases, it
                % seems like the sum is redundant, as on every fold L(k).db is initialised as matrix of zeros 
                % see L(k).db = zeros(size(L(k).b)); further back  
                L(k).db = L(k).db + L(k).alpha; % store error gradient TODO see haykin terminology for these terms
                % kron(L(k).x',L(k).alpha) produces same output as L(k).x' * L(k).alpha between output layer and hidden layer
                % for 1 output neuron, for more neurons between layers the general form ((L(k).x * L(k).alpha')')
                
                % This is the slope at output neuron times output of hidden layer which we will use to compute delta W e.g. dk * Oj
                % NB dk * Oj = error gradient a.k.a. gradient of the cost function
                L(k).dW = L(k).dW + kron(L(k).x',L(k).alpha); % kron ~ Kronecker Tensor Product
                % If A is an m-by-n matrix and B is a p-by-q matrix, then the Kronecker tensor product of matrices A and B. If A is 
                % an m-by-n matrix and B is a p-by-q matrix, then kron(A,B) is an m*p-by-n*q matrix formed by taking all possible 
                % products between the elements of A and the matrix B.
                % for synaptic weights between input neurons and hidden neurons, size(L(k).x') = 1 (m)   228 (n), 
                % size(L(k).alpha) = 11 (p)  1 (q), size(kron(L(k).x',L(k).alpha)) = 11   228 
                % m*p-by-n*q ~ 1*11x228*1 ~ 11 x 228
                % Alternatively, we can multiply L(k).x (228x1) by L(k).alpha'(1x11) to have a 228x11, then transpose it to get a 228x11
                % matrix, size((L(k).x * L(k).alpha')') ~ 228 x 11 which is equal to the Kronecker Tensor Product matrix. 
                % in other words, we make sure number of columns if first matrix matches number of rows in second matrix,
                % if we test for equality:
                % isequal((L(k).x * L(k).alpha')', kron(L(k).x',L(k).alpha)) 
                % ans =  logical  1
                % NB isequal(kron(L(k).alpha, L(k).x'), kron(L(k).alpha, L(k).x')) ans =  logical  1
                % NB isequal(kron(L(k).alpha, L(k).x'), kron(L(k).x', L(k).alpha)) ans =  logical  1
                % Alternatively element-wise multiplication .*  
                % NB isequal((L(k).x' .* L(k).alpha), (L(k).alpha .* L(k).x')) ans =  logical  1
                % Other equivalent forms isequal((L(k).x' .* L(k).alpha), (L(k).x .* L(k).alpha')')
                % Looks like kron function in this case performs the equivalent of an element wise multiplication (.*)
                % Whichever way we choose to do it, as long as we end up with a matrix sized rows (number of hidden neurons) x columns (number of inputs) 
                % we are good to go.
            end;
        end;

        % Update weights and biases, adding momentum in the form mu*L(k).vW or mu*L(k).vb  
        for k = 1:K,
            % Don't show test data to network
            if(ignoreTraining), 
                break; 
            end;
            L(k).vb = eta*L(k).db + mu*L(k).vb; % delta bias
            L(k).b = L(k).b + L(k).vb; % new bias
            L(k).vW = eta*L(k).dW + mu*L(k).vW; % delta Weights
            L(k).W = L(k).W + L(k).vW; % new Weights
        end;

        if(~ignoreTraining),
            A(m,round) = A(m,round) + (J(m, i)/(N-1)); % J ~ error vec
            J(m, i) = J(m, i)/E; % E = 1, constant
        end;
            
        % Stop criterion
        if ((i > 1) && (n == N)), % If the error is less than Delta and we are passed round 2, or error is less than theta for any give round etc, stop
            if (((A(m,round) < Delta) && ((round > 2) && (abs(A(m,round-2)-A(m,round-1) < theta) && (abs(A(m,round-1)-A(m,round)) < theta)))) || (i > numUpdates)),
                finish = 1;
            end;
        end; % otherwise, keep going in search of the holy grail
        if not(finish)
            i = i+1; n = n+1; 
            if n > N, 
                n = 1;
                round = round + 1;
                A(m,round) = 0;
            end; 
            eta = eta*alpha; % no training/learning has been done, eta is being incremented?
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
    
