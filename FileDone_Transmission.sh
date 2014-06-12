#!/opt/bin/bash
# Source variables
source email_variables.sh

echo "Fil $TR_TORRENT_NAME nedladdad!" | /opt/bin/nail -s "Transmission meddelar: $TR_TORRENT_NAME nedladdad och klar!" $EMAIL_P
#rm /tmp/filmer.txt

