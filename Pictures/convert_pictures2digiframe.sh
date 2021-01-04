#!/bin/bash
format_list="jpg jpeg JPG JPEG"
inputfolder="/input/path/to/original/pictures"
outputfolder="/output/path/to/Digiframe/pictures"
Width_Res="800"
Height_Res="600"

#ensure required folders
if [ -d "$inputfolder" ]; then
        echo "Processing $inputfolder"
else
        echo "Error: $inputfolder not found. Can not continue."
        exit 1
fi

mkdir -p "$outputfolder"
Temp_Folder="./temp_$(date +"%Y%m%d_%H%M%S")"
mkdir -p "$Temp_Folder"

# process input folder
for format in $format_list;
do
        for f in "$inputfolder"/*."$format";
        do
                if [ -f "$f" ]; then
                        filename=$(basename "$f")
                        echo
                        echo "Processing $filename"
                        echo

                        Landscape_mode=$(convert "$f" -ping -auto-orient -format "%[fx:(w>h)?1:0]" info:)

                        if [ $Landscape_mode -eq 1 ]; then
                                convert "$f"  -auto-orient -resize "$Width_Res""x>" "$outputfolder""/""${filename// /_}"
                        else
                                convert "$f"  -auto-orient -resize "x""$Height_Res"">" "$Temp_Folder""/""${filename// /_}"
                        fi
                fi
        done
done 

#Postprocess vertical pictures
last_filepath="empty"
for format in $format_list;
do
        for f in "$Temp_Folder"/*."$format";
        do
                if [ -f "$f" ]; then
                        if [ "$last_filepath" = "empty" ]; then
                                last_filepath=$f
                        else
                                montage "$last_filepath" "$f"  -auto-orient -background "black" -size "$Width_Res""x""$Height_Res" -tile "2x1" -geometry $((Width_Res / 2))"x""$Height_Res"">" -gravity center "$outputfolder"/"$(basename "${last_filepath%.*}")"_"$(basename "${f%.*}")".jpg
                                last_filepath="empty"
                        fi
                fi
        done
done

if [ "$last_filepath" != "empty" ]; then
        mv "$last_filepath" "$outputfolder/$(basename $last_filepath)"
fi

#clean up temporary folder
if [ -d "$Temp_Folder" ]; then
        rm -frd "$Temp_Folder"
fi

rm "$inputfolder"/*

#cp $INPUT /home/storage/Bilder/Digirahm/Input/