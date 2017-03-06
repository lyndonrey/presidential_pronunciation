form Get Total Duration of WAV File
	sentence Path			#Path of wav file
endform

######################################################################

Read from file... 'path$'
dur = Get total duration
writeInfoLine: dur
