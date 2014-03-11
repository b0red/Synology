#!/opt/bin/bash
#
# Script för att backaupp /scripts
#
source variables.sh
source email_variables.sh

# Create Target file
zip -r /tmp/$SHORTDATE-BackUpZip-$IP.zip /volume1/.backups /volume1/my_scripts/ -x *.git*

# Sending the file
echo Creating folder if it doest exist: $STORAGEPATH$BACKUP"; droptobox mkdir $STORAGEPATH$BACKUP
droptobox upload /tmp/$SHORTDATE-BackUpZip-$IP.zip $STORAGEPATH$BACKUP

# Mailar listan
echo "Backup" | /opt/bin/nail -s "Backupfil @$NODE" -a /tmp/$SHORTDATE-BackUpZip-$IP.zip $EMAIL_G $EMAIL_P

# Cleanup
echo Removing: $SHORTDATE-BackUpZip-$IP.zip
rm /tmp/$SHORTDATE-BackUpZip-$IP.zip

