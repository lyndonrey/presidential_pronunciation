form Get Specified Formant 
	sentence Path		#Path of wav file	
endform

#####################################################################

#writeInfoLine: "Beginning Analysis of file ", path$  
#writeInfoLine: "Getting formant ", formant

#Check if file is readable
if fileReadable(path$)	
#	writeInfoLine: "File readable"
else
#	writeInfoLine: "File not readable"
endif

##################################################################

Read from file... 'path$'
Rename: "wavIn"
start = 0
end = Get total duration
#writeInfoLine: "File finished reading. Start: ", start, " End: ", end

##################################################################

#writeInfoLine: "Getting Formants"

To Intensity... 75 0.001
Rename: "intensity"

selectObject: "Sound wavIn"
To Formant (burg)... 0.01 5 5000 0.025 50
Rename: "forms"

i = 1
for i to end*100
	selectObject: "Intensity intensity"
	y = Get value at time... i/100 cubic

	selectObject: "Formant forms"
 	f1 = Get value at time... 1 i/100 Hertz Linear
	f3 = Get value at time... 3 i/100 Hertz Linear
	f2 = Get value at time... 2 i/100 Hertz Linear
	f4 = Get value at time... 4 i/100 Hertz Linear
	f5 = Get value at time... 5 i/100 Hertz Linear

	if y <> undefined and f1 <> undefined and f3 <> undefined
		if y >= 50 and f3 >= 2000 and f2 >= 600 and f1 >= 100
			writeInfoLine: i, ", ", y, ", ", f1, ", ", f2, ", ", f3, ", ", f4, ", ", f5
		endif
	endif
endfor
