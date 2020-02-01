%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating a text sentiment analysis LSTM model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Yelp, Amazon and IMDB data from https://archive.ics.uci.edu/ml/datasets/Sentiment+Labelled+Sentences
% This dataset was created for the Paper 'From Group to Individual Labels using Deep Features', 
% Kotzias et. al,. KDD 2015

function accuracy = LSTM(XTest, XTrain, sentimentTest, sentimentTrain, numHiddenUnits, embeddingDimension, hiddenSize, maxEpochs, learnRate)

% Hyperparameters that do not change
inputSize = 1;
numClasses = numel(categories(sentimentTrain));

% Setup the LSTM Model
layers = [ ...
    sequenceInputLayer(inputSize)
    wordEmbeddingLayer(embeddingDimension,numHiddenUnits)
    lstmLayer(hiddenSize,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',maxEpochs, ...   
    'GradientThreshold',1, ... 
    'InitialLearnRate',learnRate, ... 
    'ValidationData',{XTest,sentimentTest}, ...
    'Verbose',false);

net = trainNetwork(XTrain,sentimentTrain,layers,options);
YPred = classify(net,XTest);
accuracy = sum(YPred == sentimentTest)/numel(YPred);

% Display confusion matrix
% c = confusionmat(YPred, sentimentTest);
% confusionchart(c)
end
