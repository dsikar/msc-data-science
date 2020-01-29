function [documents] = preprocessReviews(textData)
    % Convert the text data to lowercase.
    cleanTextData = lower(textData);
    % Tokenize the text.
    documents = tokenizedDocument(cleanTextData);
    % Erase punctuation.
    documents = erasePunctuation(documents);
    % Remove a list of stop words.
    documents = removeStopWords(documents);
end