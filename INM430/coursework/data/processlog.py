########################
### PROCESS LOG FILE ###
########################

# vars
iRecLen = 12

filename = "test.log"
file = open(filename, "r")
for line in file:
    line = line.rstrip()
    if(len(line) == iRecLen):
        # FlameA, FlameB and Guard detector analogue readings
        iFa = int(line[0:2], 16)
        iFb = int(line[2:4], 16)
        iG = int(line[4:6], 16)
        print(str(iFa) + "," + str(iFb) + "," + str(iG))
        # print(line)
