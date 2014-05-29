
#!/opt/bin/bash
#
# simple script to send email alert for ip changes
# version 0.1
#
# Copyrighted by Ray Chan 2009
#
# prerequisites
# - nail
# - wget
# - bash
source email_variables.sh

# If you want a simple log file, assign 1 to log_enabled, otherwise set it to 0
log_enabled=1; #0=disable, 1=enable

# date format used by log file
datestamp=`date '+%Y-%m-%d %H:%M:%S'`

# the actual command getting the public IP, change the
# URL to your php hosting if you have one
myipnow=`wget -qO - http://whatismyip.com/automation/n09230945.asp`

previp="0.0.0.0";

# path of the log file, ignore if log_enabled=0
logfile="/opt/var/log/changeip.log"

# path of nail
nail="/opt/bin/nail"

# path of the temporary file storing previous ip address
iplog="/opt/tmp/ip.log"

if [ -f $iplog ]; then
	previp='cat $iplog'
fi

if [[ $myipnow != $previp ]]; then
	#ip changed, sending email alert
    echo "Previous IP: $previp --> New IP: $myipnow" |
    $nail -s "My IP Address" $EMAIL_P
 	#write the new ip to log file
    echo $myipnow > $iplog
    if [ $log_enabled = 1 ]; then
    	echo "$datestamp IP changed, sending notification email. $previp |
        $myipnow" >> $logfile
    fi
    else
    if [ $log_enabled = 1 ]; then
    	echo "$datestamp IP is same, skipping notification. $previp |
        $myipnow" >> $logfile
 	fi
fi
