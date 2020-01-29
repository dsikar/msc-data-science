%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating a text sentiment analysis LSTM model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Yelp, Amazon and IMDB data from https://archive.ics.uci.edu/ml/datasets/Sentiment+Labelled+Sentences
% This dataset was created for the Paper 'From Group to Individual Labels using Deep Features', 
% Kotzias et. al,. KDD 2015

% % Create file with positive and negative sentiment 
% % Read in data
% filename = "all_labelled.txt";
% data = readtable(filename,'Delimiter','\t','ReadVariableNames',true); 
% head(data)
% pos = data(data.Sentiment == 1, :);
% neg = data(data.Sentiment == 0, :);

% Initial Data Exploration
% dataMean = mean(doclength(tokenizedDocument(data.Review)))
% dataStd = std(doclength(tokenizedDocument(data.Review)))
% % Exploration of data After pre-processing
% ppData = preprocessReviews(data.Review);
% ppMean = mean(doclength(preprocessReviews(ppData)))
% ppStd = std(doclength(preprocessReviews(ppData)))
% Wordcloud
% ppPos = preprocessReviews(pos.Review);
% posBag = bagOfWords(ppPos);
% topWords = topkwords(posBag, 20) %this shows the top words, if we find words
% figure
% wordcloud(posBag)
% title('Positive Word Cloud')

% ppNeg = preprocessReviews(neg.Review);
% negBag = bagOfWords(ppNeg);
% topWords = topkwords(negBag, 20) %this shows the top words, if we find words
% figure
% wordcloud(negBag)
% title('Negative Word Cloud')

% % Create histogram
% documentLengths = doclength(tokenizedDocument(data.Review));
% figure
% histogram(documentLengths,500)
% title("Document Lengths")
% xlabel("Length")
% xlim([0 80])
% ylabel("Number of Documents")

% % Partition the data into a training partition and a held-out test set.
% cvp = cvpartition(data.Sentiment,'Holdout',.1);
% dataTrain = data(cvp.training,:);
% dataTest = data(cvp.test,:);
% writetable(dataTrain, 'dataTrain.txt')
% writetable(dataTest, 'dataTest.txt')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start of code
% Read in training and testing data
trainFile = 'dataTrain.txt';
testFile = 'dataTest.txt';
dataTrain = readtable(trainFile,'Delimiter',',','ReadVariableNames',true); 
dataTest = readtable(testFile,'Delimiter',',','ReadVariableNames',true);

% Preprocess text and categorize data
reviewTrain = preprocessReviews(dataTrain.Review);
reviewTest = preprocessReviews(dataTest.Review);
sentimentTrain = categorical(dataTrain.Sentiment);
sentimentTest = categorical(dataTest.Sentiment);

% Encoding and creating word vectors
doclen = 60; % sets the vector size to 60. Most docs have 60 or fewer tokens
enc = wordEncoding(reviewTrain);
XTrain = doc2sequence(enc,reviewTrain,'Length',doclen);
XTest = doc2sequence(enc,reviewTest,'Length',doclen);
numHiddenUnits = enc.NumWords;


% % Setting up for the grid search, hyperparameters to test
% embeddingDimension = [30 50 100]; %removed 15, 200, 300
% hiddenSize = [25 50]; %removed 15 and 200
% maxEpochs = [5 8 10]; %removed 3 & 15 due to poor performance
% learnRate = [.003 .005 .01]; %removed .001 and .05

% Optimal Parameters
embeddingDimension = 50;
hiddenSize = 50;
maxEpochs = 10; 
learnRate = .003; 

% Implementing grid search on the LSTM model
for h = 1:numel(embeddingDimension)
    for i = 1:numel(hiddenSize)
        for j = 1:numel(maxEpochs)
            for k = 1:numel(learnRate)
                tic;
                accuracy = LSTM(XTest, XTrain, sentimentTest, sentimentTrain, numHiddenUnits, embeddingDimension(h), hiddenSize(i), maxEpochs(j), learnRate(k));
                t = toc;
                fprintf("Embedding Dimension: %d, Hidden Size: %d, Max Epochs: %d, Learning Rate: %.3f, Accuracy: %.5f, Time: %f\n", embeddingDimension(h), hiddenSize(i), maxEpochs(j), learnRate(k), accuracy, t)
            end
        end
    end
end


