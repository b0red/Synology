#!/opt/bin/bash
cwd=`pwd`
echo "cwd: $cwd"
subdircount=`find $cwd -maxdepth 1 -type d | wc -l`

if [ $subdircount -eq 2 ]
then
  	echo "none of interest"
else
	echo "something is in there"
fi
