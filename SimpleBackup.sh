#!/opt/bin/bash
#
# SimpleBackup.sh

# Settings
BASE1=/volume1/@appstore/sickbeard/var
#BASE2=/volume1/@appstore/sabnzbd/app
BASE3=/usr/local/sabnzbd/var
BASE4=/volume1/@appstore/couchpotatoserver/var

#/usr/local/sabnzbd/var/config.ini
TMP=/volume1/tmp
DATE=$(date +%Y%m%d-%H%M%S)

# Variables
source email_variables.sh
NODE=`uname -n`

mkdir $TMP/$DATE

# Copy configs for SickBeard
cp $BASE1/config.* $TMP/$DATE
cp $BASE1/sickbeard.* $TMP/$DATE
cp $BASE1/autoProcessTV.cfg.sample $TMP/$DATE
cp $BASE1/sickbeard.pid $TMP/$DATE 
cp $BASE3/
cp $BASE4/* $TMP/$DATE

# Configs for nzb
if [[ -d "${BASE3}" && ! -L "${BASE3}" ]] ; then
  cp $BASE3/config.ini $TMP/$DATE
fi

# Configs Transmission
cp /volume2/@appstore/transmission/var/settings.json $TMP/$DATE 

zip -r $TMP/$DATE.zip $TMP/$DATE

echo "Backup gjord: configs $DATE / $NODE" | /opt/bin/nail -s "Backupfil @$NODE (configs)" -a $TMP/$DATE.zip $EMAIL_G
                                                                                                                     
rm -rf $TMP/$DATE.zip
rm -rf $TMP/$DATE


