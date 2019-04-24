# convert coastline file extension to proper case
# 1. Retrieve authoritative list
# $ gsutil ls gs://tamucc_coastline/esi_images/ > image_list.txt
# 2. place this script in same directory as labeled_images.csv
# 3. Run this script
# $ python fix_extension_case.py

def getExtension(imagepath):
    imagefilepath = "image_list.txt"
    imagesfile = open(imagefilepath, "r")
    realExt = "";
    for line in imagesfile:
        # strip carriage return line feed from line
        line = line.rstrip()
        # avoid first line column headers
        if(line[0:5] == "gs://"):
            if(line.split(".")[0] == imagepath):
                # print("Found path %s in image_list_sample.txt " % imagepath)
                realExt = line   
                break
            
    imagesfile.close()
    # print(imagepath)
    return realExt

def fixExtensionCase():
    # 1. Open file with labels
    filepath = "labeled_images.csv"
    file = open(filepath, "r")
    file_fixed = open("labeled_images_fixed.csv","w+")
    for line in file:
        # strip carriage return line feed from line
        line = line.rstrip()
        # split using comma as delimiter
        arr = line.split(",")
        # avoid first line column headers
        if(line[0:5] == "gs://"): 
            realLine = getExtension(arr[0].split(".")[0])
            realExt = realLine.split(".")[1]
            currExt = arr[0].split(".")[1]
            if(realExt == ""):
                print("Could not find file %s in image_list.txt" % arr[0])
            elif(realExt == currExt):
                #print("%s" % line)
                file_fixed.write("%s\r\n" % line)
            else:
                file_fixed.write("%s,%s\r\n" % (realLine, line.split(",")[1]))
                #print("%s,%s" % (realLine, line.split(",")[1]))
                
    file_fixed.close()            
    file.close()
    
fixExtensionCase()  
