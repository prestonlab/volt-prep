#/bin/bash

mkdir output

FILES=volt_*.txt

for f in $FILES
do
	echo "cp $f config.txt"
	cp $f config.txt

	echo "open Build.app"
	open Build.app
	read -p "press enter key after test closes to continue..."

	file=${f%.*}
	echo $file

	twolines=$(head -2 "$f" | python data_output.py)
	echo $twolines

    subdir=output/${twolines}
    mkdir $subdir

	echo mv temp.xml ${subdir}/"$file"_"$twolines".xml
	mv output.xml ${subdir}/"$file"_"$twolines".xml
	
	echo mv volt_*.txt ${subdir}/"$file"_"$twolines".txt
	mv volt_*.txt ${subdir}/"$file"_"$twolines".txt
	
	echo "rm $f config.txt"
	rm $f config.txt
	
done