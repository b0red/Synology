#!/opt/bin/bash
#

# Get stuff
source email_variables.sh

# Debug
#set -x
#trap read debug

# Variables
NEWFOLDER="/volume2/Disk2/!Tv-Serier/!!Senaste"
SEARCHFOLDER="/volume2/Disk2/!Tv-Serier/"
NOTEBOOK="@Synology"
EMAILBODY="Veckans nya tv-serier!"
EMAILSUBJECT="Tv-Serier"
NOW=$(date +"#%G #%b #v%V")
TAGS="$NOW #TV #Tvserier"

# Delete old *weekly-files
rm -f /tmp/*weekly*
rm -rf $NEWFOLDER/*

# Check if folder exists
if [ ! -d $NEWFOLDER ]; then
  mkdir -p $NEWFOLDER
fi

# Get the week nr
DATE=$(date +%V); echo v$DATE $'\n'  > /tmp/v$DATE-weekly.txt

# Create the file
touch /tmp/v$DATE-weekly.txt
echo v$DATE $'\n'  > /tmp/v$DATE-weekly.txt

# Search for new files and create a soft link to them
find ${SEARCHFOLDER} -mtime -7 -type f -size +2048 -exec basename {} \; > /tmp/v$DATE-weekly.txt;
rm -f ${NEWFOLDER}; find ${SEARCHFOLDER} -mtime -7 -type f -size +2048 -exec ln -s '{}' ${NEWFOLDER} \;

# Count number of lines in file
NEW="`wc -l < /tmp/v$DATE-weekly.txt`"

# Set the messagevariable and strip season/episode and quality
MESS=$(perl -ne '/(.*) S..E.. (.*)SD TV.*/i;print "$1 - $2\n";' < /tmp/v$DATE-weekly.txt)

# Send mail about updates
#
# Mailto Pushover
echo "$EMAILBODY" $'\n' "$MESS" | /opt/bin/nail -s "${NEW}st nya i $EMAILSUBJECT - V.${DATE}" ${EMAIL_P}
#/tmp/v$DATE-weekly.txt ${EMAIL_P}


## Mailto Evernote
echo "${EMAILSUBJECT}" $'\n' "$MESS" | /opt/bin/nail -s "${NEW}st nya i ${EMAILSUBJECT} ${NOTEBOOK} ${TAGS}"\
 -a /tmp/v$DATE-weekly.txt ${EMAIL_E}

## Just for checking
echo "${EMAILSUBJECT} "${MESS}" ${NEW} nya i ${EMAILSUBJECT} ${NOTEBOOK} ${TAGS} ${EMAILTO} ${EMAILSECOND}"
#echo /tmp/v$DATE-weekly.txt

#echo $MESSAGE
#Delete the tempfile
rm /tmp/v$DATE-weekly.txt
