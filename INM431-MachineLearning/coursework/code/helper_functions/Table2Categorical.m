function [newTable] = Table2Categorical(trainingData, cats)
% **NO SAFETY NETS** - If you want to use this function, make sure your logical
% array will not try to convert string to double
% or email ghostbusters@gmail.com

% cats = [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false];



% T.ConfMat=categorical(T.ConfMat)

%var = trainingData.Properties.VariableNames(1)

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