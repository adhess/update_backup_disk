#!/bin/bash
DATE=`date '+%Y-%m-%d %H:%M:%S'`

ex=1
nb=0
echo ""
diff -r "$1" "$2" > "update_disk: $DATE" & pid_foo=$!
while [[ ex -eq 1 ]]; do tput rc; tput ed;
if [[ nb -eq 0 ]]; then
	printf "please wait: (-)"
	((nb++))
elif [[ nb -eq 1 ]]; then	
	printf "please wait: (\\)"
	((nb++))
elif [[ nb -eq 2 ]]; then
	printf "please wait: (|)"
	((nb++))
elif [[ nb -eq 3 ]]; then
	printf "please wait: (/)"
	nb=0
fi
sleep 1; done & pid_while=$!
wait $pid_foo
kill $pid_while
sleep 1
tput rc; tput ed;
echo ""

echo "Analyse Folders: done"

exec 3< "$(pwd)/update_disk: $DATE"

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
		var1="${var1:1}"

		var2=$(echo $var2 | cut -d ':' -f 1)
		var2="$var2/$var1"

		count=2
		nameFolder=$(echo $var2 | cut -d '/' -f 1)
		while [[ ! "$nameFolder" = "$2" && ! "$nameFolder" = "$1" ]]; do
			v=$(echo $var2 | cut -d '/' -f $count)
			nameFolder="$nameFolder/$v"
			((count++))
		done

		m1=$(echo $var2 | cut -d '/' -f $count)
		path=$m1
		while [[ ! "$m1" = "" ]]; do
			((count++))
			m1=$(echo $var2 | cut -d '/' -f $count)
			if [[ ! "$m1" = "" ]]; then
				path="$path/$m1"
			fi
		done
				
		if [[ "$nameFolder" = "$2" ]]; then
			echo "copy o: $2/$path ===> $1/$path"
			cp -r "$2/$path" "$1/$path" 
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
