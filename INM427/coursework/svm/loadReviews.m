%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loadReviews function         %
% Arguments: None              %
% Return value: reviews' table %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dataReviews] = loadReviews()
    % LOAD AMAZON AND YELP DATA
    % timer start
    % tic;
    % First we load our Amazon and Yelp data
    filename = "data/amazon_yelp_labelled.txt";
    dataReviews = readtable(filename,'TextType','string');
    % make sentiment categorical
    dataReviews.Sentiment = categorical(dataReviews.Sentiment);
    % LOAD IMDB DATA
    % Due to a bug, a different procedure is used to load IMDB data
    % For future reference, when loading IMDB data using readtable function, 
    % a number of records go missing
    % filename = "sentiment-labelled-sentences/imdb_labelled.txt";
    % dataReviews = readtable(filename,'TextType','string');
    % height(dataReviews) % expected 1000, actual 748
    % To get around this issue, we open file and process line by line

    % get a file handle
    fid = fopen('data/imdb_labelled.txt');
    % create a holding table
    SentimentAnalysis  = cell2table(cell(0,2), 'VariableNames', {'Review', 'Sentiment'});
    % read the first line
    tline = fgetl(fid);
    % keep track of line number for debugging
    i = 1;
    % loop while line tlineis a character array 
    while ischar(tline) % ischar - Determine if input is character array
        % Split line by tab as per expected format: Review \t Sentiment
        arr = strsplit(tline, '\t');
        %disp(tline);
        % Alert if more than one tab found in a line i.e. malformatted line
        if length(strfind(tline,'\t')) > 1
           disp('Found entry with more than one delimiter (tab)')
           disp(tline)
           disp(i) 
        end
        % split line into review and sentiment
        myarr = strsplit(tline, '\t');
        % create a new table with single review and sentiment
        Tnew = table(myarr(1),myarr(2),'VariableNames',{'Review','Sentiment'});
        % append to holding table
        SentimentAnalysis = [SentimentAnalysis ; Tnew];
        % read the next line
        tline = fgetl(fid);
        % and keep counting read lines
        i = i + 1;
    end
    % close file handle
    fclose(fid);
    % make Sentiment column categorical so data types match
    SentimentAnalysis.Sentiment = categorical(SentimentAnalysis.Sentiment);
    % append to working table
    dataReviews = [dataReviews ; SentimentAnalysis];
    % timer end
    % toc;    
    % return
    [myDataReviews] = dataReviews;
end