function [Y] = StatisticalNormaliz(X,Type)
%This function normalizes each column of an array using standard score or the Feature scaling normalization procedure.
%Input
%X: array of data point where each row corresponds to an observation and each column corresponds to a variable
%Type: what type of normalization
%Type=['standard']:Normalizing errors when population parameters are known. Works well for populations that are normal distribution
%Type=['scaling'] :Normalizing errors when population parameters are known. Works well for populations that are normal distribution
%Output
%Y: normalised each data array
%References:http://en.wikipedia.org/wiki/Normalization_(statistics)
%by: Joseph Santarcangelo 17/12/2014
%Also see:mean,std,repmat,Max, Min 

%Number of observations
N=length(X(:,1)); % N=size(X,1); also works
%Number of variables
M=length(X(1,:)); % M=size(X,2); also works
% output array of normalised values
Y=zeros(N,M);

switch Type
    
    case'standard'
        %Subtract mean of each Column from data
        Y=X-repmat(mean(X),N,1);
        %normalize each observation by the standard deviation of that variable
        Y=Y./repmat(std(X,0,1),N,1);
        
    case 'scaling'
        % determine the maximum value of each colunm of an array
        Max=max(X);
        % determine the minimum value of each colunm of an array
        Min=min(X);
        %array that contains the different between the maximum and minimum value for each column
        Difference=Max-Min;    
        %subtract the minimum value for each element
        Y=X-repmat(Min,N,1);
        %Divide element by the difference between the maximum and minimum value 
        Y=Y./repmat(Difference,N,1);
end

end

