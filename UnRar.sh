#!/opt/bin/bash
#
# File for mass unpacking of rar files in subfolders
# it unpacks, then deletes the residue and subfolder
# Modified by Patrick Osterlund 20140602
# original file http://bit.ly/1mIF1Lx

cwd=`pwd`

#to check if its the right dir
read -p "Are you sure this is the right dir: $cwd? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# Do stuf here
	find . -iname '*.rar' | while read FILE
	do
		d=`dirname "$FILE"`
    	f=`basename "$FILE"`

    	# only unrar part01.rar or .rar
    	echo $f | grep -q 'part[0-9]*.rar$' 2>&1 > /dev/null
    	if [ "$?" == "0" ]; then
    		echo $f | grep -q 'part01.rar$' 2>&1 > /dev/null
        	if [ "$?" == "1" ]; then
        		continue
        	fi
		fi

	cd "$d"
	echo "Unrar $f"

	# Unpack the files
	unrar x -o+ "$f"
	mv *.avi "$cwd"; rm -rf *.rar *.nfo *.sfv *.r* Sample
	cd "$cwd"
	# Remove empty folders
	find . -type d -empty -exec rmdir {} \;
	done
fi
