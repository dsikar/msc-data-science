%                     ___     __ 
%    ___  _______ ___/ (_)___/ /_
%   / _ \/ __/ -_) _  / / __/ __/
%  / .__/_/  \__/\_,_/_/\__/\__/ 
% /_/ 

% empty table 
SentimentAnalysis  = cell2table(cell(0,1), 'VariableNames', {'Score'});

for i = 1:height(dataReviews) % height(table) return number of rows
    words = string(documents(i)); 
    vec = word2vec(emb,words);
    % Ignore Function Output operator ~
    % https://uk.mathworks.com/help/matlab/matlab_prog/ignore-function-outputs.html
    [~,scores] = predict(mdl,vec);
    Tnew = table(mean(scores(:,1)),'VariableNames',{'Score'});
    SentimentAnalysis = [SentimentAnalysis ; Tnew];
end

% Concatenate to table
dataReviews = [dataReviews, SentimentAnalysis];

% true negative
TN = sum((dataReviews.Score <= 0) & (dataReviews.Sentiment == '0'))
% true positive
TP = sum((dataReviews.Score > 0) & (dataReviews.Sentiment == '1'))
% false negative
FN = sum((dataReviews.Score <= 0) & (dataReviews.Sentiment == '1'))
% false positive
FP = sum((dataReviews.Score > 0) & (dataReviews.Sentiment == '0'))

SVM_Acc = (TN + TP) / (FN + FP + TN + TP)

disp(SVM_Acc)
