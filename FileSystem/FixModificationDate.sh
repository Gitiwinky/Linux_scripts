#!/bin/sh

NbYears=+1
NbMonths=+9
NbDays=+16
NbHours=+10
NbMins=+0

for file in *.*; do
	extension="${file##*.}"
	if  [ $extension != "sh" ]
	then
		new_date="$(date -R -r $file) $NbYears Years $NbMonths Months $NbDays days $NbHours hours $NbMins minutes"
		new_file="$(date -d "$new_date" +%Y%m%d_%H%M%SA.$extension)"
		echo "$file" "$new_file"
		mv "$file" "$new_file"
		touch -d "$new_date" "$new_file"
	fi
done 
