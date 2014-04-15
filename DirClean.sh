#!/opt/bin/bash
#
# DirClean.sh
#
# File for deleting all those @eaDirs√'√s on the system
# Patrick Osterlund
# Created: 2014-04-15

cd /
find . -name "@eaDir" -type d -print |while read FILENAME; do rm -rf "${FILENAME}"; done
