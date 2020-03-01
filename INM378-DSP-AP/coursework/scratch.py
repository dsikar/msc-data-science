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
# assume amplitude is 1
modulator_samples = np.sin(2 * np.pi * f* timepoints)
plt.figure(figsize=(15,5))
plt.scatter(timepoints,modulator_samples)
plt.legend(['Course 2Hz Sine Wave'])
plt.tight_layout()
plt.show()
plt.interactive(False)