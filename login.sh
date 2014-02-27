#!/opt/bin/bash

#This sub routine sends an email to say someone just logged in to the Command Line Interface

# Source variables
source email_variables.sh

# To turn echo off so the logged in user doesn't know the script is running
# redirect stdout(1) and stderr(2) to null:
exec 1>/dev/null 2>/dev/null

#set the subject of the email
var_subject="NAS - A user has logged in to the CLI"

#send the email
echo "NAS - A user has logged in to the CLI" | /opt/bin/nail -s $var_subject $EMAIL_P

#if the email fails nail will create a file dead.letter, test to see if it exists and if so wait 1 minute and then resend

while ls "/root/dead.letter"
    do
#     echo email failed - waiting 1 minute and then re-sending
      sleep 60
      rm "/root/dead.letter"
      echo "NAS - A user has logged in to the CLI" | /opt/bin/nail -s "$var_subject" $EMAIL_P
      sleep 60
done

sleep 60
exit
