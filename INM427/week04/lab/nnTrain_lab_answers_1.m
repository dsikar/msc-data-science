% EXERCISE 9
% Download tutorial4files from Moodle, unzip and open Matlab file nnTrain.m. This file contains a
% simple Matlab implementation (outside the neural net toolbox) of the backpropagation learning algorithm
% for single-hidden layer networks. If you run this file it will perform cross-validation on the promoter dataset
% as seen in class, mapping DNA sequences as input to promoter/non-promoter classifications in the output.
% The code splits the data into M folds and it trains M networks, computing the average accuracy.

% 9.1 Check in the code how the average accuracy is calculated. Does it use the mean squared error function
% seen in class or hit and miss counts? 
% 9.2 Does it refer to the training set or the validation set accuracy?
% 9.3 Find where in the code the number of folds can be specied. 
% 9.4 Change the number of folds and run the file, inspecting how this changes the accuracy and running time.
% Average accuracy: 0.556604 - Finished training with 1 folds in 1 seconds
% Average accuracy: 0.885714 - Finished training with 5 folds in 1 seconds 
% Average accuracy: 0.930000 - Finished training with 10 folds in 2 seconds  
% Average accuracy: 0.950000 - Finished training with 20 folds in 3 seconds 
% Average accuracy: 0.850000 - Finished training with 50 folds in 6 seconds 
% Average accuracy: 0.880000 - Finished training with 100 folds in 11 seconds 

% 9.5 Why should the data be shuffled when using cross-validation? 
% See Haykin pg. 213 - 218
% 9.6 Why should shuffle be turned off for reproducibility?
% TBA
% 9.7 Change the various stopping criteria and inspect the results. Analyse how the use of number of epochs
% alone as stopping criterion compares with the use of various values for Delta.
% 9.8 You can also change the number of hidden neurons, the learning rate, the learning rate decay, and the
% momentun constant and inspect results.
% 9.9 Plot the evolution of the training set error and the validation set error.
% 9.10 You can use smote oversampling or not. Should using it make any difference in the case of this dataset?
% 9.11 How would you go about implementing weight decay?

% EXERCISE 10 Backpropagation through multiple hiddden layers - TBC

close all; clear all; clc;

[folder, name, ext] = fileparts(which('nnTrain'));
cd(folder);

% Adding necessary files to the java path
javaaddpath([folder '\weka.jar']);
javaaddpath([folder '\SMOTE.jar']);

% Preparing the data

file = 'promoter';
X = csvread([file '.csv'], 0, 0);

t = X(:,size(X,2));
X(:,size(X,2)) = [];

Type = 'scaling';

%This function normalizes each column of an array  using the standard score or feature scaling.
X = StatisticalNormaliz(X,Type);
X = (X * 2) - 1; 
X = X';

E = 1;
originalInputSize = size(X,2);
classes = [1 -1];

% Get generator
st = rand('state');
                                                                                                                                                         
% Network Init
K = 2; % Number of Layers
etaInit = 0.01; % Learning Rate Initial Value
Delta = 0.1; % Stop Criterion #1
theta = 0.01; % Stop Criterion #2
numUpdates = 10000; % Max number of epochs
N = size(X,2); % Number of Input Vectors
h = 11; % Number of Hidden Neurons
alpha = 0.999; % Learning Rate Decay Factor
mu = 0.1; % Momentum constant;
M = 10; % Number of Folds (N = leave-one-out) % 9.3 Number of folds
shuffle = 1; % Shuffle control (turn it off for reproductibility)
smote = 0; % SMOTE oversampling

% Running time
t1=datestr(now, 'dd/mm/yy-HH:MM:SS');
t11=datevec(datenum(t1));

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
    X = [X ; t' ; randn(1,numExamples)]';
    X = sortrows(X,numAttr+2)';
    t = X(numAttr+1,:); 
    X = X(1:numAttr,:);
end;

% M-fold cross validation
answer = zeros(M, floor(N/M));
target = zeros(M, floor(N/M));

tp = zeros(1, M);
fp = zeros(1, M);
tn = zeros(1, M);
fn = zeros(1, M);
acc = zeros(1, M);

avgAcc = 0;

for m = 1:M,
    
    if(smote && m <= oldInputSize),
        fprintf('Training fold %d/%d...\n', m, oldInputSize);
    else
        if(m <= oldInputSize),
            fprintf('Training fold %d/%d...\n', m, M);
        end;
    end;
    
    % Layers initialization - for multi-class learning, this should be
    % changed
    L(1).W = (rand(h,numAttr)-0.5)*0.2;
    L(1).b = (rand(h,1)-0.5)*0.2;
    L(2).W = (rand(1,h)-0.5)*0.2;
    L(2).b = (rand(1,1)-0.5)*0.2;

    for k = 1:K,
        L(k).vb = zeros(size(L(k).b));
        L(k).vW = zeros(size(L(k).W));
    end;

    % Sequential Error Backpropagation Training
    n = 1; i = 1; finish = 0; eta = etaInit;
    round = 1; A(m,round) = 0;
    while not(finish),
        
        % Checking if it is a fold example
        ignoreTraining = 0; ignoreTesting = 0;
        if ((n > ((m-1)*floor(N/M))) && (n <= (m*floor(N/M)))),
           ignoreTraining = 1;
           if((n > N) && ~shuffle),
               ignoreTesting = 1;
               break;
            end;
        end;
        
        J(m, i) = 0;
        if(~ignoreTraining),
            for(k = 1:K),
                L(k).db = zeros(size(L(k).b));
                L(k).dW = zeros(size(L(k).W));
            end;
        end;

        for(ep = n:(n+E-1)),
            
            if((ep > N) || ignoreTraining),
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
            J(m, i) = J(m, i)/E;
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
    % 9.2 Validation set is used to calculate accuracy
    if(~ignoreTesting), 
        index = 0;
        for n = ((m-1)*floor(N/M))+1:m*floor(N/M),      
            index = index + 1;
            L(1).x = X(:,n);
            for k = 1:K, % NB Input potentials, activations and network outputs are calculated with weights
                L(k).u = L(k).W*L(k).x + L(k).b; % and biases obtained from trained network
                L(k).o = tanh(L(k).u);
                L(k+1).x = L(k).o;
            end;
            answer(m,index) = L(K).o;
            target(m,index) = t(n);

            if abs(answer(m,index) - target(m,index)) < (abs(classes(2) - classes(1))/2),
                if(abs(answer(m,index)-classes(1)) < abs(answer(m,index)-classes(2))), %TP case
                    tp(m) = tp(m) + 1; %TP case, + output, + target
                else                     
                    tn(m) = tn(m) + 1; %TN case, - output, - target
                end;
            else
                if(answer(m,index) > 0), %FP case, + output, - target
                    fp(m) = fp(m) + 1;
                else                     %FN case, - output, + target
                    fn(m) = fn(m) + 1;
                end;
            end;
        end;
    end;
    % 9.1 Code uses "hit and miss counts to compute accuracy   
    acc(m) = acc(m) + ((tp(m) + tn(m))/(tp(m) + tn(m) + fp(m) + fn(m)));
    avgAcc = avgAcc + (acc(m)/M);

end;

fprintf('Average accuracy: %f\n\n', avgAcc);

% Running time
t2=datestr(now, 'dd/mm/yy-HH:MM:SS');
t22=datevec(datenum(t2));
time_interval_in_seconds = etime(t22,t11);
fprintf('Finished training with %d folds in %d seconds \n', M, time_interval_in_seconds);
    