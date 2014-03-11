#!/opt/bin/bash

# Edits:
# 2014-02-04	Tog bort mail t gmail, on√digt

# Source variables
source email_variables.sh
source variables.sh

# Debug 
#echo os:$OS IP: $IP
#echo "$SUBJECT: $NODE/$IP" $FIL $EMAIL_G $EMAIL_P


# Internal variables
SUBJECT="Filmlista"
DATE=$(date +%Y%m%d)
touch /tmp/$DATE-filmer.txt
FIL=/tmp/$DATE-filmer.txt

# Delete old file
find /tmp/*-filmer.txt -type f -mtime +7 -exec rm -f {} \;

# Do the listing and mail it
find /volume2/Disk2 -type f \( -iname "*.avi" -o -iname "*.m*v" -o -iname "*.iso" -o -iname "*.mp*" \) | sort -do /tmp/$DATE-filmer.txt
echo "$SUBJECT" | /opt/bin/nail -s "$SUBJECT: $NODE/$IP" -a $FIL $EMAIL_P

# Delete old files
rm $FIL
