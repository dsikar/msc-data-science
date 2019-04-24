# Coastline data - munge data to fit into flowers tensorflow example model i.e.
# split into eval_set.csv (10%) and train_set.csv(90%)
# NB Python 2.7 is current version in shell so any uncommented print debugs will not work

def splitCoastlineData(filepath):
    # expected format:
    # gs://tamucc_coastline/esi_images/IMG_3059_SecDE_Spr12.jpg,9,Sheltered tidal flats
    import numpy as np
    # initialise empty work array
    filearr = np.empty((0,2), dtype='uint8') 
    # open file
    file = open(filepath, "r")
    for line in file:
        # strip carriage return line feed from line
        line = line.rstrip()
        # split using comma as delimiter
        arr = line.split(",")
        # avoid first line column headers
        if(line[0:5] == "gs://"):
            #print("loc: %s, label: %s" % (arr[0], arr[1]))
            # append to work array
            filearr = np.append(filearr, [[arr[0],arr[1]]],axis = 0)
    # close file - good practice
    file.close()
    # array bounds
    lower_bound = 0
    upper_bound = filearr[0:,0].size;
    sample_size = int(upper_bound * 0.1) # 10% holdout
    #print("Eval set size:", sample_size)
    # NB array is zero indexed and randint generates random numbers from lower bound inclusive
    # to upper bound exclusive
    eval_set_idx = np.random.randint(lower_bound, upper_bound, sample_size, dtype='int')
    #print(eval_set_idx) # indexes for our evaluation set
    # open files
    eval_file = open("eval_set.csv","w+")
    train_file = open("train_set.csv","w+")    
    for i in range(upper_bound):
        csv_line = filearr[i,0] + ',' + filearr[i,1]
        if i in (eval_set_idx):
            # append to eval_set.csv
            eval_file.write("%s\r\n" % csv_line)    
        else: # 90% of indexes not in eval index set get appended to training set 
            # append to train_set.csv
            train_file.write("%s\r\n" % csv_line)            
    # close files - now we have a training and evaluation set (holdout) and can get
    # back to our coastline tensorflow code
    eval_file.close()
    train_file.close()

splitCoastlineData("labeled_images.csv")
