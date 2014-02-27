#!/opt/bin/bash

# Edits:
# 2014-02-04	Tog bort mail t gmail, on√digt

# Source variables
source email_variables.sh

# Variables
SUBJECT="Filmlista"
DATE=$(date +%Y%m%d)
touch /tmp/$DATE-filmer.txt
FIL=/tmp/$DATE-filmer.txt

# Get OS & other stuff
OS=`uname`
NODE=`uname -n`

# Store IP
case $OS in
   Linux) IP=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`;;
   FreeBSD|OpenBSD) IP=`ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}'` ;;
   SunOS) IP=`ifconfig -a | grep inet | grep -v '127.0.0.1' | awk '{ print $2} '` ;;
   *) IP="Unknown";;
esac

#Delete old file
find /tmp/*-filmer.txt -type f -mtime +7 -exec rm -f {} \;

# Do the listing and mail it
find /volume2/Disk2 -type f \( -iname "*.avi" -o -iname "*.m*v" -o -iname "*.iso" -o -iname "*.mp*" \) | sort -do /tmp/$DATE-filmer.txt
echo "$SUBJECT" | /opt/bin/nail -s "$SUBJECT: $NODE/$IP" -a $FIL $EMAIL_P

# Debug 
# echo os:$OS IP: $IP
# echo "$SUBJECT: $NODE/$IP" $FIL $EMAIL_G $EMAIL_P

# Delete old files
rm $FIL
