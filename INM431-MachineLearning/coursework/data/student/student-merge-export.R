# Student data modified merge script

# set working directory - modify as required, assume student.zip has been unzipped to working directory
# setwd("\\\\nsq024vs/u8/aczd097/MyDocs/git/msc-data-science/INM431-MachineLearning/coursework/data/student/")

# clear global environment
rm(list = ls())

# Note, columns G1 and G2 in both files are numeric and enclosed in double quotes
d1=read.table("student-mat.csv",sep=";",header=TRUE) # nrow(d1) = 395, ncol(d1) = 33
d2=read.table("student-por.csv",sep=";",header=TRUE) # nrow(d2) = 649, ncol(d2) = 33

# merge "by=" 13 columns
d3=merge(d1,d2,by=c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")) # 13 columns
# print(nrow(d3)) # nrow(d2) = 382, ncol(d2) = 53 ~ 13 + 20 + 20 ~ ***NOT GOOD*** !!! Not sure this is what authors meant to do, will email

# export, for the record - with some modified column headers (all excluding listed 13) and 20 (duplicates) columns
write.table(d3, "student-merged-original.csv", row.names = FALSE, sep = ";", col.names = TRUE, quote = TRUE)

# next, use all
d4=merge(d1,d2,all=TRUE) # 1044 rows x 33 cols ~ so far so good
# paste(nrow(d4), ncol(d4))
# how many dupes across all columns?
# nb need plyr to count:
# install.packages("plyr")
# library(plyr)
# count(duplicated(d1)) 
#       x freq
# 1 FALSE 1044

# no duplicates, good, let's go with that
# Export merged records to be consumed by Matlab
# Option one, all strings will be enclosed in double quotes, including column headers
# write.table(d4, "student-merged-all-records.csv", row.names = FALSE, sep = ";", col.names = TRUE, quote = TRUE)


# Option two, no quotes enclosing column headers, quotes enclosing strings for observations (rows). All numeric characters will not
# be enclosed in double quote, differing from columns G1 and G2 in the original files supplied by authors.
write.table(d4[0,], "student-merged-all-records.csv", row.names = FALSE, sep = ";", col.names = TRUE, quote = FALSE)
# and the remaining rows with, for non-numeric columns
write.table(d4[1:nrow(d4),], "student-merged-all-records.csv", row.names = FALSE, sep = ";", col.names = FALSE, quote = TRUE, append = TRUE)

# Sanity checks

# R deduping - copy last two rows onto the files again
# d5=read.table("student-mat-2-dupes.csv",sep=";",header=TRUE) # 397 rows x 33 cols OK
# paste(nrow(d5), ncol(d5))
# count(duplicated(d5)) 
#       x freq
# 1 FALSE  395
# 2  TRUE    2
# Good, no deduping required

# Load output file, check rowcount tallies
# d6=read.table("student-merged-all-records.csv",sep=";",header=TRUE) #1044 rows x 33 cols ~ All good
# paste(nrow(d6), ncol(d6))
