#! /bin/bash

FILES=/home/lyndon/Documents/Thesis/Sounds/Faetar/*
TOTALLENGTH=0

for f in $FILES
do
	SINGLELENGTH=`sox $f -n stat 2>&1 | sed -n 's#^Length (seconds):[^0-9]*\([0-9.]*\)$#\1#p'`
	IFS='.' read -a TRIMMED <<< "$SINGLELENGTH"
	echo $TRIMMED	
	echo $TOTALLENGTH
	$((TOTALLENGTH += TRIMMED))
done
	
echo $TOTALLENGTH
