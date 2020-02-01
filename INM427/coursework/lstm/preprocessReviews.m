function [data] = preprocessReviews(reviews)
% Make reviews all lowercase
reviews = lower(reviews);

% Tokenize the reviews
data = tokenizedDocument(reviews);

% Remove punctuation
data = erasePunctuation(data);

% Remove a list of stop words.
% data = removeStopWords(data);
% Remove stop words
% bag = bagOfWords(data);
% topWords = topkwords(bag, 20) %this shows the top words, if we find words
% to remove, can add to the customStopWords list below
% customStopWords = ["the" "and" "this" "food" "for" "place" "with" "had" "that" "were" "are" "but" "have" "was" "you" "they" "here" "all" "our" "their" "also" "will" "very" "get" "there" "come"];
% data = removeWords(data, customStopWords);

% Remove short words
% data = removeShortWords(data, 2);

% Normalize words
% data = normalizeWords(data)

end