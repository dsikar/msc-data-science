# TODO - see that code complies with "Coding Style and Comments" - compare with Johan's modules
import numpy as np;
import matplotlib.pyplot as plt;

def circcorr(k, s, i):
    """
    Perform a correlation between kernel k and control signal s
    starting at index i.

    Parameters
    ----------
    k : (N,) array_like
        First one-dimensional input array - the kernel.
    s : (M,) array_like
        Second one-dimensional input array - the control signal.
    i : int
        The index where k aligns with s

    Returns
    -------
    c : ndarray
        Discrete, linear correlation of `k` and `s` at s index i.
    i : int
        Incremented index.

    Examples
    --------
    >>> circcorr([0,1,0],[1,1,1,1,1,-1,1,1,1,1,1],0)
    (array([0., 1., 0.]), 1)

    >>> circcorr([0,1,0],[1,1,1,1,1,-1,1,1,1,1,1],6)
    (array([ 0., -1.,  0.]), 7)

    >>> circcorr([0,-1,0],[1,1,1,1,1,-1,1,1,1,1,1],6)
    (array([0., 1., 0.]), 7)

    >>> circcorr([0,1,0],[1,1,1,1,1,-1,1,1,1,1,1],12)
    (array([0., 1., 0.]), 1)
    """
    import numpy as np

    if len(k) > len(s):
        raise ValueError('Kernel size cannot be greater than control signal size.')

    # Pad control signal
    p = np.size(k) - 1;
    s = np.concatenate([np.ones(p), s, np.ones(p)]);

    # Validate index
    if i > (np.size(s) - (p + 1)):
        i = 0;

    # Correlate
    l = np.size(k);
    c = k * s[i:i + l];

    # Adjust index
    i = i + 1;

    return c, i;

# Let's assume the 2Hz sine function is the "modulator wave" as per lab 2.
f = 2 # freq in Hz
samplerate = 40 # sample rate in Hz - deliberately low sample rate for visualisation
duration = 2 # signal duration in seconds
timepoints = np.arange(samplerate * duration) / samplerate

# Let's reassign modulator_samples in case we rerun this cell
modulator_samples = np.sin(2 * np.pi * f * timepoints)
# Now let's use the 2Hz sine wave as our modulator:
# First we set up the filter and input control:
kernel = [0,1,0];
ksize = np.size(kernel);
# input_control = [1,1,1,1,1,-1,-1,-1,-1,-1,-1];
input_control = np.concatenate([np.ones(10), -1 * np.ones(10)]);
# the index for our circcorr function
index = 0;
# pad the modulator
padding = ksize - 1;
modulator_samples = np.concatenate([np.ones(padding), modulator_samples, np.ones(padding)]);
# now we loop through the modulator samples
start = 0;
end = (np.size(modulator_samples) - (padding + 1))
# output signal
output = [];
for i in range(start, end):
  controllable_FIR, index = circcorr(kernel,input_control,index)
  i_controllable_FIR = controllable_FIR[::-1]
  dot_product = np.dot(i_controllable_FIR,modulator_samples[i:i+ksize])
  output = np.append(output, dot_product);
# trim the output to match timepoints
trim_size = np.abs(np.size(output)-np.size(timepoints));
output = output[trim_size:end]
# plot the output
plt.figure(figsize=(15,5))
plt.scatter(timepoints,output)
plt.legend(['Filter modulated by sine function'])
plt.tight_layout()