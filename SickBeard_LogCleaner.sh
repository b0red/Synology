#!/opt/bin/bash   

LOGFILE=/usr/local/var/sickbeard/Logs
#LOGFILE=/var/log/syslog    
DATE=`date +"%b %e" --date="-30"`    
sed -i "/$DATE/d" $LOGFILE
