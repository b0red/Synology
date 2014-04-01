#!/opt/bin/bash   

LOGFILE=/volume1/@appstore/sickbeard/var/Logs

#LOGFILE=/var/log/syslog    
DATE=`date +"%b %e" --date="-30"`    
sed -i "/$DATE/d" $LOGFILE
