#!/opt/bin/bash
#
# CurrentTvList.sh
# File for generating a current list of stored tvshows on my nas
# Patrick Osterlund
# 

#set -x
#trap read debug

# Settings
#
NEWTMPFOLDER="/volume1/tmp/tvtemps/"
NEWTMPFILE="TmpTvlisting.txt"
SIMPLER=$NEWTMPFOLDER$NEWTMPFILE
SMALL=2
MEDIUM=14
LARGE=30

# Clear screen; remove later
clear

#check if dir exists
mkdir -p ${NEWTMPFOLDER}

#check if file exists
if [ -f $SIMPLER ];
then
   echo "File: $NEWTMPFILE exists in $NEWTMPFOLDER" $'\n'
  
   FILEDATE=$(date -r $SIMPLER)
	#Check if file is newer than the existing one
	if [[ $SIMPLER -nt $FILEDATE ]]; then
		echo "$SIMPLER is newer than $FILEDATE"
	else
		echo "file created $FILEDATE is newer than file created; $SIMPLER"
	fi
   echo "and it was created: $FILEDATE" #$'\n\n'
   echo "File was created: " > $SIMPLER 
   echo $FILEDATE >> $SIMPLER $'\n'
else
   echo "File $NEWTMPFILE does not exists in $NEWTMPFOLDER, creating it"
   touch $SIMPLER;
fi

# Mostly for checking if all went well:
echo "looking for $NEWTMPFILE here: $NEWTMPFOLDER"

# Small list
echo "New shows last ${SMALL} days: " $'\n' >> $SIMPLER
find /volume2/Disk2/!Tv-Serier/ -type f -mtime -$SMALL -size +2048 -exec basename {} \; | sed 's/\.[^.]*$//'\
>> $SIMPLER

# Medium list
echo $'\n' "New shows last ${MEDIUM} days: " $'\n' >> $SIMPLER
find /volume2/Disk2/!Tv-Serier/ -type f -mtime -$MEDIUM -size +2048\
 -exec basename {} \; | sed 's/\.[^.]*$//' >> $SIMPLER | sort -df


# dirlisting
# find /volume2/Disk2/!Tv-Serier/ -maxdepth 1 -mindepth 1 -type d -print -exec basename {} \; | sort

# Not in use right now
# Large list
#echo $'\n' "New shows last ${LARGE} days: " $'\n' >> $SIMPLER
#find /volume2/Disk2/!Tv-Serier/ -type f -mtime -$LARGE -size +2048\
# -exec basename {} \; | sed 's/\.[^.]*$//' >> $SIMPLER | sort -df
##

#temp testdir listing
for f in $NEWTMPFOLDER
   do
      if [[ $SIMPLER -nt $FILEDATE ]]; then
	 echo "yes: "$f
	 #then ;
	 else
		echo "11"
	  # Do stuf 
	  # find /volume2/Disk2/!Tv-Serier/ -maxdepth 1 -mindepth 1 -type d -print -exec basename {} \; | sort
      fi
   done

