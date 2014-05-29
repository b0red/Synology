#!/opt/bin/bash
#
# DirClean.sh
#
# File for deleting all those @eaDirs on the system
# Patrick Osterlund
# Created: 2014-04-15

clear; echo "Delete all @eaDirs from top down"

read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
	then
		cd /
		find . -name "@eaDir" -type d -print |while read FILENAME; do rm -rf "${FILENAME}"; done
	else
		"Ok, nothing to do, quitting!"; exit 1
fi
echo "Done cleaning!"
