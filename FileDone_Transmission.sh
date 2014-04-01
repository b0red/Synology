#!/opt/bin/bash
# Source variables
source email_variables.sh

echo "Fil nedladdad!" | /opt/bin/nail -s "Transmission" $EMAIL_P
#rm /tmp/filmer.txt

