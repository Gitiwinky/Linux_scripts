#!/bin/bash
format_list="webm mkv mpg"
inputfolder="/input/path/to/original/video"
outputfolder="/ouput/path/to/mp4"

for format in $format_list;
do
	for f in "$inputfolder"/*."$format";
	do
		 if [ -f "$f" ]; then
				filename=$(basename "$f")
				echo
				echo "Processing $filename"
				echo
				filename_nospace=${filename// /_}
				ffmpeg -i "$f" -f mp4 -c:v libx264 -c:a aac -c:s none -y "$outputfolder""/""${filename_nospace%.$format}.mp4"
		fi
	done 
done
