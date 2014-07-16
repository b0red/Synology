#!/usr/bin/env bash
#
# Variables inc file
# Contains stuff that shouldn't go into git

DATE=$(date +%Y%m%d-%H%M%S)
SHORTDATE=$(date +%Y%m%d)

MACHINE=$(uname -n)
OS=`uname`
IO=""
OPS=`uname -o`
RELEASE=`uname -r`
PLACE=`uname -n`

DB_DEST='/Machines'
#MACHINE=$OPS
WORK='/Work'
BACKUP='/Backups'
Common='/Common'

# No-ip.com login
# No-IP uses emails as passwords, so make sure that you encode the @ as %40
USERNAME=mrakita
PASSWORD=2g00d4upsr%26N
HOST=osterlund.hopto.org

#STORAGEPATH=${DB_DEST}/${OS}/${OPS}_${RELEASE}
STORAGEPATH=${DB_DEST}/${OS}/${MACHINE}

#store IP
case $OS in
	Linux) IP=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`;;
	FreeBSD|OpenBSD) IP=`ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}'` ;;
	SunOS) IP=`ifconfig -a | grep inet | grep -v '127.0.0.1' | awk '{ print $2} '` ;;
	*) IP="Unknown";;
esac

if test "$1" = "P"
  then
    clear
    echo Date: $DATE; echo Shortdate: $SHORTDATE
    echo 
    echo Machine: $MACHINE
    echo OS: $OS
    echo OPS: $OPS
    echo Release: $RELEASE
    echo Place: $PLACE
    echo Destination: $DB_DEST
    echo Machine: $MACHINE
    echo OPS: $OPS
    echo StoragePath: $STORAGEPATH
    echo IP: $IP

fi
