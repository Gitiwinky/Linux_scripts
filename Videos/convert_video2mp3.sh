#!/bin/bash
format_list="webm mp4 mkv mpg"
inputfolder="/input/path/to/videos"
outputfolder="/output/path/to/mp3"

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
				ffmpeg -i "$f" -f mp3 -c:v none -c:a libmp3lame -c:s none -y "$outputfolder""/""${filename_nospace%.$format}.mp3"
		fi
	done 
done
