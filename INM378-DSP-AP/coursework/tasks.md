# Cousework template:
https://moodle.city.ac.uk/mod/url/view.php?id=1501133

# Coursework tasks
From:
```
https://moodle.city.ac.uk/mod/resource/view.php?id=1501137
```
1. For the data part, apply prediction and classification on a given dataset using Fourier analysis, filtering and
correlation.  
**Common DSP**: Program a controllable FIR filter, i.e. a filter that changes its characteristics over time in
response to a control signal. To change in the characteristics of the filter, you need to change the filter
coefficients.  
  
If you do the data track, you
can implement the filter by implementing the convolution with the coefficients in a loop over the
samples (you can’t use the ready-made convolution function, because they don’t allow changing coefficients).
If you do the data track, implement the function to be used offline with the filter modulated by
a sine function at 2Hz. (40%)  
  
2.   
b. Data:
Digit recognition: Program a character classifier using 2d-correlation to classify digits. (25%)
Time series prediction: Use Fourier analysis for implementing a time series predictor on financial
data. (25%)  

d. Data (for pairs):
Frequency domain filtering: Implement the filter from task 1 in the frequency domain. Use the STFT
and compare the results with task 1. Explain what the advantages and disadvantages of processing in
the frequency and the time domain are. (50%)
  
3. Report: Write a short report that explains how you solved the tasks, where to find the solutions in your
submitted code and any specific points you would like me to pay attention to (no more than 1500 words)
(10%).  
  
**Background Information and Support**  
For every step of the coursework, relevant information, examples and data will be provided in the lectures
and tutorials.  
  
**Coding Style and Comments**
* Every method in your code must be commented w.r.t. its purpose, its parameters and its return values.  
* Use meaningful variable names and explain their use in comments, if you are not using Python make sure your code is properly indented. 
* Comments and style will be marked together with the code.  
