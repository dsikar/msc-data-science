# https://moodle.city.ac.uk/mod/page/view.php?id=1174260

import csv     # imports the csv module
import sys      # imports the sys module

# total rows
total = 0;

f = open('TB_burden_countries_2014-09-29.csv') # opens the csv file

# Exercises Part-1: Some elementary Python tasks
# 1. Count the number of rows in the csv file you've chosen.

for row in csv.reader(f):
    total = total + 1
print("Total rowcount =", total)

# reset
total = 0;
f.seek(0)
errcount = 0
# 2. Pick one of the columns with numeric data and calculate the average value using a loop
for row in csv.reader(f):
    total = total + 1
    # skip column headers
    if(total > 1):
        try:
            colsum = colsum + float(row[11])
        except ValueError:
            errcount += 1
# subtract errors
total = total - errcount
# subtract column headers
total = total - 1
# calculate average            
colavg = colsum/total
print("Average e_prev_num_lo (column 12) = ", colavg)
print("Errorcount =", errcount)

# 3. Now, repeat step-2 above but this time find the averages for years 1990 and 2011.
#    Have you observed any difference?
# reset
total = 0;
f.seek(0)
total1990 = 0
total2011 = 0
colsum1990 = 0;
colsum2011 = 0;
errcount1990 = 0
errcount2011 = 0

for row in csv.reader(f):
    total = total + 1
    # skip column headers
    if(total > 1):
        # 1990
        if(int(row[5]) == 1990):
            try:
                total1990 += 1
                colsum1990 = colsum1990 + float(row[11])
            except ValueError:
                errcount1990 += 1
        if(int(row[5]) == 2011):
            try:
                total2011 += 1
                colsum2011 = colsum2011 + float(row[11])
            except ValueError:
                errcount2011 += 1
# subtract errors
total1990 = total1990 - errcount1990
# subtract column headers N/A
# calculate average            
colavg1990 = colsum1990/total1990
print("Total rowcount 1990 =", total1990)
print("Average 1990 e_prev_num_lo (column 12) = ", colavg1990)
print("Errorcount 1990 =", errcount1990)

# subtract errors
total2011 = total2011 - errcount2011
# subtract column headers N/A
# calculate average            
colavg2011 = colsum2011/total2011
print("Total rowcount 2011 =", total2011)
print("Average 2011 e_prev_num_lo (column 12) = ", colavg2011)
print("Errorcount 2011 =", errcount2011)

"""
OUTPUT

Total rowcount = 4904
Average e_prev_num_lo (column 12) =  567593.7190392482
Errorcount = 11
Total rowcount 1990 = 211
Average 1990 e_prev_num_lo (column 12) =  44379.73417061612
Errorcount 1990 = 1
Total rowcount 2011 = 216
Average 2011 e_prev_num_lo (column 12) =  33320.0524537037
Errorcount 2011 = 1

CONCLUSION: Lower incidence of TB from 1990 to 2011
"""