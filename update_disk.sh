#!/bin/bash
isOnly="false"
isIn="false"
mainPath=""
fullPath=""
isDiff="false"
isMR="false"
firstFile=""
diff -r $1 $2 > modification_history
for str in $(cat "modification_history") 
do 
	if [ "$str" = "Only" ]
	then
		isOnly="true"
	elif [ "$str" = "in" ]
	then
		isIn="true"
	elif [ "$isOnly" = "true" ] && [ "$isIn" = "true" ] && [ "$mainPath" = "" ]
	then
		
		fullPath="${str::-1}"
		mainPath=$(echo ${str::-1}| cut -d'/' -f 1)
	elif [ "$isOnly" = "true" ] && [ "$isIn" = "true" ]
	then
#		echo "$path || $2  \n  "
        if [ "$mainPath" = "$2" ]
        then
			secondPath=$( echo $fullPath|sed "s/$2//" )
			echo "exist only: cp $fullPath/$str ====> $1$secondPath/$str"
			cp -r "$fullPath/$str" "$1$secondPath/$str"
		fi
		isOnly="false"
		isIn="false"
		mainPath=""
		fullPath=""
	fi
	if [ "$str" = "diff" ]
	then
		isDiff="true"
	elif [ "$str" = "-r" ]
	then
		isMR="true"
	elif [ "$isDiff" = "true" ] && [ "$isMR" = "true" ] && [ "$firstFile" = "" ]
	then
		firstFile="$str"
	elif [ "$isDiff" = "true" ] && [ "$isMR" = "true" ]
	then
		echo "same file: cp -----> $firstFile"
        secondFile="$str"
        rm "$firstFile"
        cp "$secondFile" "$firstFile"

		isDiff="false"
		isMR="false"
		firstFile=""
	fi
done
echo "done we will check another time for unupdated changes"

diff -r $1 $2 > final_result

