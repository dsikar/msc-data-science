# https://moodle.city.ac.uk/mod/page/view.php?id=1174260

# Exercises (DIY) - Part 2

import numpy as np

# 1. Create an array of int ranging from 5-15
b = np.arange(5, 16, 1) # numpy.arange([start, ]stop, [step, ]dtype=None)
print(b)

# 2. Create an array containing 7 evenly spaced numbers between 0 and 23
b = np.linspace(0, 23, 7) # numpy.linspace(start, stop, num=50, endpoint=True, retstep=False, dtype=None)[source]
print(b)

# 3.  generate an artificial numpy array with values between -1 and 1 that follow a uniform data distribution.
b = np.random.uniform(-1, 1, 50)  # numpy.random.uniform(low=0.0, high=1.0, size=None)
print(b)

# 4. Visualise the array in an histogram in matplotlib.

import matplotlib.pyplot as plt 
"""
matplotlib.pyplot.hist(x, bins=None, range=None, normed=False, weights=None, cumulative=False, bottom=None, histtype='bar', 
align='mid', orientation='vertical', rwidth=None, log=False, color=None, label=None, stacked=False, hold=None, data=None,
 **kwargs)
"""
plt.hist(b, 20)

# 5. Create two random numpy arrays with 10 elements. Find the Euclidean distance between the arrays using arithmetic operators, 
#    hint: numpy has a sqrt function
# Definition
# The Euclidean distance between points p and q is the length of the line segment connecting them 
# In plain english, Euclidean distance between two arrays is the square root, of the squares of the differences of the array 
# elements
a = np.random.rand(10)
b = np.random.rand(10)
print(a)
print(b)
c = np.sqrt(np.sum(np.square(a - b)))
print(c)


