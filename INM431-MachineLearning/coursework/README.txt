
	*************************************************************************
	** STUDENT PERFORMANCE EVALUATION USING NAIVE BAYES AND RANDOM FORESTS **
	*************************************************************************

INM431 Machine Learning Coursework

Daniel Sikar - MSc DS PT2

README

1. Naive Bayes

Please run:

coursework/code/NaiveBayes/StudentNBClassifierModel.m

making sure all sub-directories below coursework directory are added to path.

The script will load the best trained models for three cases; excluding intermediate grades G1 and G2, including G1, including G1 and G2.

The script will generate confusion matrices for the best models NB_mdl.mat, NB_mdl_G1.mat and NB_mdl_G1_G2.mat.

The models were obtained by running script NBGridSearch.m, which in turn uses trainNaiveBayesModel.m and coursework/code/helper_functions/Table2Categorical.m. Note sections had to be commented in and out during the process. The code will still run a grid search for the best model.

2. Random Forests

Please run:

coursework/code/RandomForest/StudentRFClassifierModel.m

making sure all sub-directories below coursework directory are added to path.

The script will load the best trained models for three cases; excluding intermediate grades G1 and G2, including G1, including G1 and G2.

The script will generate confusion matrices for the best models mdl.mat, mdl_G1.mat and mdl_G1_G2.mat.

The models were obtained by running script studentRFClassifier.m. Note sections had to be commented in and out during the process. The code will still run for the best model.

3. Data origin and pre-processing

Data was obtained from https://archive.ics.uci.edu/ml/datasets/Student+Performance, consisting of two files, one for maths, on for portuguese subject, then merged into one and further processed to format and add a fail/pass column. 

The final processed data, together with a pre-processing script can be found in coursework/code/data

4. Contributions by Judith Grieves

Judith Grieves switched to part-time during the term. She helped with choosing the data set and some of the initial data analysis and plots.

