#!/bin/bash
inputfolder="/input/path/to/original/objects"
outputfolder="/output/path/to/reprocessed/mail/attachements"

format_pict_list="jpg jpeg JPG JPEG"
Pict_Res="2048"

format_vid_list="mp4 MP4 mov MOV avi AVI 3gp 3GP"
Vid_Res="720"

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

# process pictures
for format in $format_pict_list;
do
        for f in "$inputfolder"/*."$format";
        do
                if [ -f "$f" ]; then
                        filename=$(basename $f)
                        echo
                        echo "Processing $filename"
                        echo

                        Landscape_mode=$(convert $f -ping -auto-orient -format "%[fx:(w>h)?1:0]" info:)

                        if [ $Landscape_mode -eq 1 ]; then
                                convert "$f"  -auto-orient -resize "$Pict_Res""x>" "$outputfolder""/""${filename// /_}"
                        else
                                convert "$f"  -auto-orient -resize "x""$Pict_Res"">" "$Temp_Folder""/""${filename// /_}"
                        fi
                fi
        done
done 

#Postprocess vertical pictures
last_filepath="empty"
for format in $format_pict_list;
do
        for f in "$Temp_Folder"/*."$format";
        do
                if [ "$last_filepath" = "empty" ]; then
                        last_filepath=$f
                else
                        montage "$last_filepath" "$f"  -auto-orient -background "black" -size "$Width_Res""x""$Height_Res" -tile "2x1" -geometry $((Width_Res / 2))"x""$Height_Res"">" -gravity center "$outputfolder"/$(basename $last_filepath "."$format)_"$(basename $f "."$format).$format"
                        last_filepath="empty"
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

#cp $INPUT /home/storage/Bilder/Digirahm/Input/