% Implementation of a Gaussian Naive Bayes on a given Dataset

% Dataset
data = [6.00 180 12 1 ;
        5.92 190 11 1 ;
        5.58 170 12 1 ;
        5.92 165 10 1 ;
        5.00 100 06 0 ;
        5.50 150 08 0 ;
        5.42 130 07 0 ;
        5.75 150 09 0] ;

% X : Feature Matrix ; Y : Target Column Vector
X = data(:, 1:3);
Y = data(:, 4);

% Target Classes (this won't be used in the computations, just in the prints)
class = ["Male" "Female"];

% Samples
sample_1 = [6.0 130 8];
sample_2 = [5.6 167 9];

% Class Probabilities (P(sex = Male) and P(sex = Female)
P_male = sum(Y)/ size(Y, 1); % probability of male
P_female = sum(1 - Y) / size(Y, 1); % probability of female

% Conditional Density Function of Height, Weight and Foot Size given the
% Class. We assume that each of them follows a Normal Distribution, 
% and we need to find its parameters 
   
    % Conditioned by Sex = Male
% Height : conditional density function of height given class Male
% Mean and Std of the Gaussian are estimated from the data
mean_height_cond_male = mean(X(1:4, 1)); % 1:4 correspond to the Male rows
std_height_cond_male = std(X(1:4, 1));
% Weight
mean_weight_cond_male = mean(X(1:4, 2));
std_weight_cond_male = std(X(1:4, 2));
% Foot Size
mean_foot_cond_male = mean(X(1:4, 3));
std_foot_cond_male = std(X(1:4, 3));

    % Conditioned by Sex = Female
% Height
mean_height_cond_female = mean(X(5:8, 1)); % 5:8 correspond to the Female rows
std_height_cond_female = std(X(5:8, 1));
% Weight
mean_weight_cond_female = mean(X(5:8, 2));
std_weight_cond_female = std(X(5:8, 2));
% Foot Size
mean_foot_cond_female = mean(X(5:8, 3));
std_foot_cond_female = std(X(5:8, 3));

% A print about our decision rule (this is just a detail)
fprintf("\nAccording to the MAP (Maximum A Posteriori) decision rule, the prediction \nof our algorithm is the class that has the highest Class Conditional Probability \nor just the nominator of it since we don't need to normalize in order to compare.\n")

% Let's compute Class Conditional Probabilities (Not Normalized) of the first Sample
fprintf("\nFirst Sample : [%d %d %d]\n", sample_1)

    % P(Class = Male | h = 6, w = 130, f = 8) = P(Class = Male) *
    % p(h = 6 | Class = Male) * p(w = 130 | Class = Male) * p(f = 8 | Class = Male)   
P_male_cond_s1 = P_male * normpdf(6, mean_height_cond_male, std_height_cond_male) * ...
                normpdf(130, mean_weight_cond_male, std_weight_cond_male) * ...
                normpdf(8, mean_foot_cond_male, std_foot_cond_male) ;

    % P(Class = Female | h = 6, w = 130, f = 8) = P(Class = Female) *
    % p(h = 6 | Class = Female) * p(w = 130 | Class = Female) * p(f = 8 | Class = Female) 
P_female_cond_s1 = P_female * normpdf(6, mean_height_cond_female, std_height_cond_female) * ...
                normpdf(130, mean_weight_cond_female, std_weight_cond_female) * ...
                normpdf(8, mean_foot_cond_female, std_foot_cond_female) ;
  

fprintf("The Male class conditional probability (non normalized) is %f\n", P_male_cond_s1)
fprintf("The Female class conditional probability (non normalized) is %f\n", P_female_cond_s1)
fprintf("The prediction of the class of our first sample is : %s\n", class(1 + (P_male_cond_s1 <= P_female_cond_s1))) % don't pay too much attention to this line, it's just meant for displaying the winner

% Let's compute Class Conditional Probabilities (Not Normalized) of the second Sample
fprintf("\nSecond Sample :[%d %d %d]\n", sample_2)

    % P(Class = Male | h = 5.6, w = 167, f = 9) = P(Class = Male) *
    % p(h = 5.6 | Class = Male) * p(w = 167 | Class = Male) * p(f = 9 | Class = Male)
P_male_cond_s2 = P_male * normpdf(5.6, mean_height_cond_male, std_height_cond_male) * ...
                normpdf(167, mean_weight_cond_male, std_weight_cond_male) * ...
                normpdf(9, mean_foot_cond_male, std_foot_cond_male) ;

    % P(Class = Female | h = 5.6, w = 167, f = 9) = P(Class = Female) *
    % p(h = 5.6 | Class = Female) * p(w = 167 | Class = Female) * p(f = 9 | Class = Female)
   
P_female_cond_s2 = P_female * normpdf(5.6, mean_height_cond_female, std_height_cond_female) * ...
                normpdf(167, mean_weight_cond_female, std_weight_cond_female) * ...
                normpdf(9, mean_foot_cond_female, std_foot_cond_female) ;           

fprintf("The Male class conditional probability (non normalized) is %f\n", P_male_cond_s2)
fprintf("The Female class conditional probability (non normalized) is %f\n", P_female_cond_s2)
fprintf("The prediction of the class of our second sample is : %s\n", class(1 + (P_male_cond_s2 <= P_female_cond_s2)))

% BONUS : INTERACTIVE PART
% In this part, I am going to define a new test sample and we're going to
% predict its class (whether it's a Male or Female) according to the
% Gaussian Naive Bayes we trained on our dataset before.
% Feel free to change the values of the sample (keep them real though) and
% see what the algorithm is going to predict each time. Don't worry if you
% see 0.000000 as the Class Conditional Probabilities, the values are not 0
% but they're very small, use the Command Window to print them and you'll
% see their real values.

% Bonus Sample
sample_bonus = [6 190 9]; % CHANGE THESE VALUES AND RERUN THE CODE TO SEE THE NEW PREDICTION

% Let's compute Class Conditional Probabilities (Not Normalized) of this bonus Sample
fprintf("\nBonus Sample : [%d %d %d] <----- CHANGE MY VALUES IN THE CODE !\n", sample_bonus)

    % P(Class = Male | h, w, f) = P(Class = Male) * p(h | Class = Male) * 
    % p(w | Class = Male) * p(f | Class = Male)   
P_male_cond_sb = P_male * normpdf(sample_bonus(1), mean_height_cond_male, std_height_cond_male) * ...
                normpdf(sample_bonus(2), mean_weight_cond_male, std_weight_cond_male) * ...
                normpdf(sample_bonus(3), mean_foot_cond_male, std_foot_cond_male) ;

    % P(Class = Female | h, w, f) = P(Class = Female) *
    % p(h | Class = Female) * p(w | Class = Female) * p(f | Class = Female) 
P_female_cond_sb = P_female * normpdf(sample_bonus(1), mean_height_cond_female, std_height_cond_female) * ...
                normpdf(sample_bonus(2), mean_weight_cond_female, std_weight_cond_female) * ...
                normpdf(sample_bonus(3), mean_foot_cond_female, std_foot_cond_female) ;
  

fprintf("The Male class conditional probability (non normalized) is %f\n", P_male_cond_sb)
fprintf("The Female class conditional probability (non normalized) is %f\n", P_female_cond_sb)
fprintf("The prediction of the class of our bonus sample is : %s\n", class(1 + (P_male_cond_sb <= P_female_cond_sb))) % don't pay too much attention to this line, it's just meant for displaying the winner

