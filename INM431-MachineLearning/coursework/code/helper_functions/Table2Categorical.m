function [newTable] = Table2Categorical(trainingData, cats)
% If you want to use this function, make sure your logical
% array will not lead to string to double conversions, i.e. no string data
% types allowed in trainingData table.
% cats array will look like this:
% cats = [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false];

% trainingData(:,3) = categorical(trainingData(:,3))
% Error using categorical (line 282)
% Conversion from table not supported.  Extract data from one or more table 
% variables into an array using dot or brace subscripting. Then
% convert the array to a categorical array.

%newcol = categorical(table2array(trainingData(:,7)))
%trainingData.(7) = categorical(trainingData.(7));

%class(trainingData.(7))

for i=1:size(cats,2),
    if cats(i) == true,
        trainingData.(i) = categorical(trainingData.(i));
    else 
        trainingData.(i) = double(trainingData.(i));
    end;
end;

newTable = trainingData;