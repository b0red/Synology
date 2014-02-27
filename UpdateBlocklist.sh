#!/opt/bin/bash
#
# taken from http://forum.buffalo.nas-central.org/viewtopic.php?f=71&t=23581

TO_ADDR=[Y0PJsEZEGe4ubHnYaE37EEuNRWfkNO@api.pushover.net]

# First kill the transmission-daemon 
PID="`pidof transmission-daemon`"
if [ -n "$PID" ]; then
        kill $PID
fi

echo -n "Waiting for the daemon to exit "
sleep 2

COUNT=1
while [ -n "`pidof transmission-daemon`" ]; do
        COUNT=$((COUNT + 1))
        if [ $COUNT -gt 60 ]; then
                echo -n "transmission-daemon doesn't respond, killing it with -9"
                kill -9 `pidof transmission-daemon`
                break
        fi
        sleep 2
        echo -n "."
done

echo " done"

# Update the line below with the location of your blocklists directory
# cd $HOME/.config/transmission-daemon/blocklists/
cd /volume2/@appstore/transmission/blocklists

# Create a temp file to store the message to email
TMPFILE=`mktemp -t transmission.XXXXXXXXXX`

# define the URL of where to obtain the blocklists and the names of the lists
# URL="http://list.iblocklist.com/?list="bt_level1&fileformat=p2p&archiveformat=gz
URL="http://list.iblocklist.com/?list="
URL_NAME[1]="bt_level1"
URL_NAME[2]="bt_level2"
URL_NAME[3]="bt_level3"
URL_NAME[4]="bt_spyware"
URL_NAME[5]="bt_microsoft"
URL_NAME[6]="ecqbsykllnadihkdirsh"

# wget the files from the above URL
EMAIL_MSG="The following blocklists have been updated; \n"
for (( x=1; x<=${#URL_NAME[@]}; c++ ))
do
    WGET_OUTPUT=$(2>&1 wget --timestamping --progress=dot:mega "$URL${URL_NAME[x]}") 
    if [ $? -ne 0 ]; then
        EMAIL_MSG="$EMAIL_MSG \n // WARNING: ${URL_NAME[x]}.gz was NOT updated // \n $WGET_OUTPUT \n"
    else
        EMAIL_MSG="$EMAIL_MSG \n${URL_NAME[x]} - Success."
        if [ -f ${URL_NAME[x]}.gz ]; then
          rm -f ${URL_NAME[x]}.bin
          rm -f ${URL_NAME[x]}
          gunzip ${URL_NAME[x]}.gz
        fi
    fi
    let x=x+1
done

# Write the $EMAIL_MSG string to a temp file and send email (using Nail which you must install seperatly)
echo -e $EMAIL_MSG >$TMPFILE
SUBJECT="Blocklist Update"
NAIL=/opt/bin/nail
$NAIL -v -s "$SUBJECT"  "$TO_ADDR" < $TMPFILE
rm $TMPFILE

# Restart the daemon
# transmission-daemon
 /usr/local/transmission/bin/transmission-daemon

# Now wait for four minutes to allow the BIN files to be created
# (Transmission scans the blocklists directory and automatically creates the files)
# If you add lots of Blocklists, you might want to increase the delay to allow the files to be created
sleep 5m

# Transmission initially creates a zero byte .bin file while processing the blocklist
# Check the .bin filesizes > 0, then delete the gz/text files that were downloaded.

#for (( x=1; x<=${#URL_NAME[@]}; c++ ))
#do
#    if [ $(stat -c%s "${URL_NAME[x]}.bin") <> 0 ]; then
#      rm -f ${URL_NAME[x]}
#      let x=x+1
#    fi
#done
