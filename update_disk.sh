#!/bin/bash

diff -r "$1" "$2" > data
exec 3< "$(pwd)/data"

line=""
i=0
while read -u 3 -r line 
do
	
	m1=$(echo $line | cut -d ' ' -f 1)
	m2=$(echo $line | cut -d ' ' -f 2)

	if [[ "$m1" = "Only" && "$m2" = "in" ]]; then
		count=3

		m1=$(echo $line | cut -d ' ' -f $count)
		var2=$m1
		while [[ ! "$m1" = "" ]]; do
			((count++))
			m1=$(echo $line | cut -d ' ' -f $count)
			if [[ ! "$m1" = "" ]]; then
				var2="$var2 $m1"
			fi
		done
		var1=$(echo $var2 | cut -d ':' -f 2)
		var1=$(echo $var1 | cut -d ' ' -f 2)

		var2=$(echo $var2 | cut -d ':' -f 1)
		var2="$var2/$var1"

		count=2

		m1=$(echo $var2 | cut -d '/' -f $count)
		path=$m1
		while [[ ! "$m1" = "" ]]; do
			((count++))
			m1=$(echo $var2 | cut -d '/' -f $count)
			if [[ ! "$m1" = "" ]]; then
				path="$path/$m1"
			fi
		done

		nameFolder=$(echo $var2 | cut -d '/' -f 1)

		if [[ "$nameFolder" = "$2" ]]; then
			cp -r "$2/$path" "$1/$path" 
			echo "copy o: $2/$path ===> $1"
		fi

	elif [[ "$m1" = "diff" && "$m2" = "-r" ]]; then
		count=3

		m1=$(echo $line | cut -d ' ' -f $count)
		var2=$m1
		while [[ ! "$m1" = "" ]]; do
			((count++))
			m1=$(echo $line | cut -d ' ' -f $count)
			if [[ ! "$m1" = "" ]]; then
				var2="$var2 $m1"
			fi
		done

		file1=""
		file2=""
		if [[ $(echo $var2 | cut -d '"' -f 2) = $var2 ]]; then
			file1="$(echo $var2 | cut -d ' ' -f 1)"
			file2="$(echo $var2 | cut -d ' ' -f 2)"
		else
			file1=$(echo $var2 | cut -d '"' -f 2)
			file2=$(echo $var2 | cut -d '"' -f 4)
		fi

		rm "$file1"
		cp "$file2" "$file1"
		echo "copy d: $file2 ==> $file1"

	elif [[ "$m1" = "Binary" && "$m2" = "files" ]]; then
		count=3

		m1=$(echo $line | cut -d ' ' -f $count)
		var2=$m1
		while [[ ! "$m1" = "" ]]; do
			((count++))
			m1=$(echo $line | cut -d ' ' -f $count)
			if [[ ! "$m1" = "" ]]; then
				if [[ "$m1" = "and" ]]; then
					file1="$var2"
					var2=""
				elif [[ "$m1" = "differ" ]]; then
					file2="${var2:1}"
					var2=""
				else
					var2="$var2 $m1"
				fi
			fi
		done
		rm "$file1"
		cp "$file2" "$file1"
		echo "copy b: $file2 ==> $file1"
	fi
	
done
echo "--------------*******************************************---------------"
diff -r "$1" "$2"