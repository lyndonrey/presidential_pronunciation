#!/usr/bin/env python

from subprocess import call
from multiprocessing import Process as Task, Queue
import time, sys, collections, subprocess, glob


def callPraat(wavIn, dataOut):
    """ Calls the praat formant getter script on the wav file param, and prints to file """
    f = open(dataOut, "a") # This variable is what I'm piping stdout of the praat call to
    return call(["praat", "--run", "formants-master.praat", wavIn], stdout=f)



def removeUndefs(fileIn):
    """ Removes '--undefined--' values from output, this helps with stats things """
    f = open(fileIn, "r+")
    lines = f.readlines()
    f.seek(0) # This is necessary to return to the beginning of the file
    
    for line in lines:
        if "--undefined--" not in line:
            f.write(line)
    f.truncate()
    f.close()
    print ("Done removing undefined measurements")


def getTotalDuration(fileIn):
    """ Returns the total duration of each file to enable efficiency calculations """ 
    return subprocess.Popen(["praat", "--run", fileIn], stdout=subprocess.PIPE).communicate()[0]



directory = sys.argv[1] # The input directory must be in quotes (in Bash anyway) or else it wildcards weird
# print (directory)
# Get all the wav files from directory to parse 
wavs = glob.glob(directory)

dataFile = sys.argv[2] # Output file for data:w

f = open(dataFile, "w+") # Create file if it doesn't exist
f.close()


sumOfProcesses = 0 # The summed time total of all processed wavs


# For each wav in the directory specified...
for wav in wavs:
   # print ("total Duration:", getTotalDuration(wav))
    
    workers = []

    # Specify and start the task
    child = Task(target=callPraat, args=(wav, dataFile))
    child.start()
    workers.append(child)

    # These few lines just give a command line counter so it seems more interactive
    progress = 0
    while any(i.is_alive() for i in workers):
        progress += 1
        print ("Running time (s):", progress, wav.split("/")[-1], end="\r")
        time.sleep(1)
    
    sumOfProcesses += progress
    print ("\nCurrent total (s):", sumOfProcesses)

print ("Total analysis time (s):", sumOfProcesses)
print ("Removing undefined measurements")
removeUndefs(dataFile)
