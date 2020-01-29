%                   _ __  _                               __  _         
%    ___  ___  ___ (_) /_(_)  _____   ___  ___ ___ ____ _/ /_(_)  _____ 
%   / _ \/ _ \(_-</ / __/ / |/ / -_) / _ \/ -_) _ `/ _ `/ __/ / |/ / -_)
%  / .__/\___/___/_/\__/_/|___/\__/ /_//_/\__/\_, /\_,_/\__/_/|___/\__/ 
% /_/   _____  _______/ /__                  /___/                      
% | |/|/ / _ \/ __/ _  (_-<                                             
% |__,__/\___/_/  \_,_/___/  

% From https://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html
% Download link: http://www.cs.uic.edu/~liub/FBS/opinion-lexicon-English.rar
% Based on article "Mining and summarizing customer reviews"

% Load an opinion lexicon listing positive and negative words.
% Read positive words NB lexicon files must be at script directory level
% fopen returns a file id
fidPositive = fopen('positive-words.txt');
% textscan returns a cell array...
C = textscan(fidPositive,'%s','CommentStyle',';');
% ...which we can examine with celldisp(C) or by indexing e.g. C{1}{2}
% convert cell array to string
wordsPositive = string(C{1}); % class(wordsPositive) ~ 'string'
% Read negative words
%fidNegative = fopen(fullfile('opinion-lexicon-English','negative-words.txt'));
fidNegative = fopen('negative-words.txt');
C = textscan(fidNegative,'%s','CommentStyle',';');
wordsNegative = string(C{1}); % class(wordsNegative) ~ 'string'
% Close all open files
fclose all;
% Concatenate string with labeled words
words = [wordsPositive;wordsNegative]; % class(words) ~ 'string'
% create labels, initialise table cells to NaN
labels = categorical(nan(numel(words),1)); % class(labels) ~ 'categorical'
% from start to number of positive words, assign "Positive" category to cells
labels(1:numel(wordsPositive)) = "Positive";
% from end of number of positive words plus one, to end of labels' table, 
% assign "Negative" category to cells
labels(numel(wordsPositive)+1:end) = "Negative";
% create a data table with columns and column headers
data = table(words,labels,'VariableNames',{'Word','Label'}); % class(data) ~ 'table'

%View the first few words labeled as positive.
idx = data.Label == "Positive"; % class(idx) ~ 'logical'
head(data(idx,:))
%View the first few words labeled as negative.
idx = data.Label == "Negative";
head(data(idx,:))
%                      __            __          __   ___             
%  _    _____  _______/ / ___ __ _  / /  ___ ___/ /__/ (_)__  ___ ____
% | |/|/ / _ \/ __/ _  / / -_)  ' \/ _ \/ -_) _  / _  / / _ \/ _ `(_-<
% |__,__/\___/_/  \_,_/  \__/_/_/_/_.__/\__/\_,_/\_,_/_/_//_/\_, /___/
%                                                           /___/     
% Load a pretrained word embedding using fastTextWordEmbedding. 
% This function requires Text Analytics Toolbox™ Model for fastText 
% English 16 Billion Token Word Embedding support package. 
emb = fastTextWordEmbedding; % class(emb) ~ 'wordEmbedding'

% To train the sentiment classifier, convert the words to word vectors using 
%the pretrained word embedding emb. 

% First remove the words that do not appear in the word embedding emb.
idx = ~isVocabularyWord(emb,data.Word);
data(idx,:) = [];
%Set aside 10% of the words at random for testing.
numWords = size(data,1);

%                   __  _ __  _         
%    ___  ___ _____/ /_(_) /_(_)__  ___ 
%   / _ \/ _ `/ __/ __/ / __/ / _ \/ _ \
%  / .__/\_,_/_/  \__/_/\__/_/\___/_//_/
% /_/                                   
%  Define a random partition of a specified size on a data set
cvp = cvpartition(numWords,'HoldOut',0.1);
dataTrain = data(training(cvp),:); % class(training(cvp)) ~ 'logical'
dataTest = data(test(cvp),:); % class(dataTest) ~ 'table'
% Set training words aside
wordsTrain = dataTrain.Word; % class(wordsTrain) ~ 'string' (vector)

%                      __  ___                
%  _    _____  _______/ / |_  |  _  _____ ____
% | |/|/ / _ \/ __/ _  / / __/  | |/ / -_) __/
% |__,__/\___/_/  \_,_/ /____/  |___/\__/\__/ 
%                                            
% See "Efficient Estimation of Word Representations in Vector Space"
% https://arxiv.org/pdf/1301.3781.pdf

%Convert the words in the training data to word vectors using word2vec.
XTrain = word2vec(emb,wordsTrain); % class(XTrain) ~ 'single'
% NB word2vec returns Matrix of word embedding vectors
YTrain = dataTrain.Label; % class(YTrain) ~ 'categorical'

% Train classifier 
% NB Documentation mentions different kernels may be used, as well as
% hyperparameters - TODO examine options as examiner asks for
% hyperparameter tuning

%    _____   ____  ___  __           _      _          
%   / __/ | / /  |/  / / /________ _(_)__  (_)__  ___ _
%  _\ \ | |/ / /|_/ / / __/ __/ _ `/ / _ \/ / _ \/ _ `/
% /___/ |___/_/  /_/  \__/_/  \_,_/_/_//_/_/_//_/\_, / 
%                                               /___/  

%mdl = fitcsvm(XTrain,YTrain, 'KernelFunction', 'linear', 'BoxConstraint', 0.01); % class(mdl) ~ 'ClassificationSVM'

%mdl = fitcsvm(XTrain,YTrain, 'KernelFunction', 'linear', 'BoxConstraint', 0.04); % class(mdl) ~ 'ClassificationSVM'

%mdl = fitcsvm(XTrain,YTrain,'OptimizeHyperparameters','auto',...
%    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
%    'expected-improvement-plus'))

%|=====================================================================================================|
%| Iter | Eval   | Objective   | Objective   | BestSoFar   | BestSoFar   | BoxConstraint|  KernelScale |
%|      | result |             | runtime     | (observed)  | (estim.)    |              |              |
%|=====================================================================================================|
%|    1 | Best   |     0.29819 |      17.319 |     0.29819 |     0.29819 |    0.0048315 |       93.972 |
%|    2 | Best   |     0.18546 |      611.77 |     0.18546 |     0.19149 |        253.9 |     0.035237 |
%|    3 | Best   |     0.06233 |      408.86 |     0.06233 |    0.075102 |     0.065031 |      0.01202 |
%|    4 | Accept |     0.70181 |       318.4 |     0.06233 |    0.062373 |       262.44 |       882.28 |
%|    5 | Accept |     0.25119 |      647.96 |     0.06233 |    0.062381 |       2.1846 |    0.0042306 |
%(...)
% etc

% save model

saveCompactModel(mdl, "BestSVMModel.mat")

% mdl = 

%  ClassificationSVM
%             ResponseName: 'Y'
%    CategoricalPredictors: []
%               ClassNames: [Positive    Negative]
%           ScoreTransform: 'none'
%          NumObservations: 5872
%                    Alpha: [754×1 single]
%                     Bias: -0.0032
%         KernelParameters: [1×1 struct]
%           BoxConstraints: [5872×1 double]
%          ConvergenceInfo: [1×1 struct]
%          IsSupportVector: [5872×1 logical]
%                   Solver: 'SMO'
                                     
% test classifier
wordsTest = dataTest.Word; % class(wordsTest) ~ 'string' (vector)
XTest = word2vec(emb,wordsTest); % class(XTest) ~ 'single' (vector) 
YTest = dataTest.Label; % class(YTest) ~ 'categorical'

%                     ___     __ 
%    ___  _______ ___/ (_)___/ /_
%   / _ \/ __/ -_) _  / / __/ __/
%  / .__/_/  \__/\_,_/_/\__/\__/ 
% /_/                            

%Predict the sentiment labels of the test word vectors.
[YPred,scores] = predict(mdl,XTest); % class(YPred) ~ 'categorical'
                                     % class(scores) ~ 'single' (vector)
%Visualize the classification accuracy in a confusion matrix.
figure
confusionchart(YTest,YPred);

% At this point we have an SVM model for our positive and negative sentiment 
% words and now proceed to test it against our reviews.
% Timer
tic;
dataReviews = loadReviews();

% Calculate Sentiment of Collections of Amazon, IMDB and Yelp Reviews 
% NB This has performed poorly with the SVM classifier. One reason may be 
% the positive, negative words' lexicon does not have good coverage in the
% Yelp corpus. The UCI "Sentiment Labelled Sentences Data Set" was created
% for "From Group to Individual Labels using Deep Features" 
% http://mdenil.com/media/papers/2015-deep-multi-instance-learning.pdf
% which AFAIK does cite source for list of positive and negative terms

% Load review column
textData = dataReviews.Review; % class(textData) ~ string

% textData(2:10)

% Load a pretrained word embedding - previously loaded
% emb = fastTextWordEmbedding; % class(emb) ~ wordEmbedding

% preprocess reviews
documents = preprocessReviews(textData); % class(documents) ~ tokenizedDocument

% remove non-existing words i.e. words present in fastTextWordEmbedding
% not present in Review column
idx = ~isVocabularyWord(emb,documents.Vocabulary); % class(idx) ~ logical
documents = removeWords(documents,idx);

%                     ___     __ 
%    ___  _______ ___/ (_)___/ /_
%   / _ \/ __/ -_) _  / / __/ __/
%  / .__/_/  \__/\_,_/_/\__/\__/ 
% /_/ 

% Score empty holding table 
SentimentAnalysis  = cell2table(cell(0,1), 'VariableNames', {'Score'});

for i = 1:height(dataReviews) % height(table) return number of rows
    words = string(documents(i)); 
    vec = word2vec(emb,words);
    % Ignore Function Output operator ~
    % https://uk.mathworks.com/help/matlab/matlab_prog/ignore-function-outputs.html
    [~,scores] = predict(mdl,vec);
    Tnew = table(mean(scores(:,1)),'VariableNames',{'Score'});
    % Append to holding table
    SentimentAnalysis = [SentimentAnalysis ; Tnew];
end

% Concatenate to dataReviews table
dataReviews = [dataReviews, SentimentAnalysis];  

%  ___ ___________ _________ _______ __
% / _ `/ __/ __/ // / __/ _ `/ __/ // /
% \_,_/\__/\__/\_,_/_/  \_,_/\__/\_, / 
%                               /___/  

% Compute TN, TP, FN, FP and accuracy

% true negative
TN = sum((dataReviews.Score <= 0) & (dataReviews.Sentiment == '0'));
% true positive
TP = sum((dataReviews.Score > 0) & (dataReviews.Sentiment == '1'));
% false negative
FN = sum((dataReviews.Score <= 0) & (dataReviews.Sentiment == '1'));
% false positive
FP = sum((dataReviews.Score > 0) & (dataReviews.Sentiment == '0'));
% Accuracy
SVM_Acc = (TN + TP) / (FN + FP + TN + TP);
% Timer
toc;
% Display output for grid search
disp(SVM_Acc)
