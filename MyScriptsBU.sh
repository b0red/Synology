#!/opt/bin/bash

# Variables
NODE=`uname -n`
NAME=BackUP

# Source variables
source email_variables.sh


DATE=$(date +%Y%m%d-%H%M%S)

# Target file
#TARTARGET="/volume1/my_scripts/backup-$DATE.tar.gz"
zip -r /tmp/$DATE-$NAME /volume1/my_scripts /volume1/.backups


#mailar listan
echo "Backup" | /opt/bin/nail -s "Backupfil @$NODE" -a /tmp/$DATE-$NAME.zip $EMAIL_G $EMAIL_P
rm /tmp/$DATE-$NAME.zip

