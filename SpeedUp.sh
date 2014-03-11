#!/opt/bin/bash
#
# Script for speeding up the NAS
# It works by stopping some services and also deletes the @eaDirs
#

clear; echo; echo "Do you want to start the services? [halt or run]: "

read hro
case $hro in
	[hH] | [hH][aA][lL][tT] )
	echo "Stopping and disabling them..."
	/usr/syno/etc/rc.d/S??synoindexd.sh stop
	/usr/syno/etc/rc.d/S??synomkflvd.sh stop
	/usr/syno/etc/rc.d/S??synomkthumbd.sh stop
	killall -9 convert
	killall -9 ffmpeg
	# If you don't use Download Station (but e.g. SABnzbd instead):
	/usr/syno/etc/rc.d/S??pgsql.sh stop
	
	# Stop them from starting next reboot or ugrade
	chmod a-x /usr/syno/etc/rc.d/S??synoindexd.sh
	chmod a-x /usr/syno/etc/rc.d/S??synomkflvd.sh
	chmod a-x /usr/syno/etc/rc.d/S??synomkthumbd.sh
	# If you don't use Download Station (but e.g. SABnzbd instead):
	chmod a-x /usr/syno/etc/rc.d/S??pgsql.sh
	
	#@eaDirs for iTunes
	#cd /; find . -type d -name "@eaDir" -print0 | xargs -0 rm -rf
	chmod 000 S66fileindexd.sh S66synoindexd.sh S77synomkthumbd.sh S88synomkflvd.sh S99iTunes.sh
	;;


	[rR] | [r|R][u|U][n|N] )
	echo "Reanabling and starting services...";
	
	chmod a+x /usr/syno/etc/rc.d/S??synoindexd.sh
	chmod a+x /usr/syno/etc/rc.d/S??synomkflvd.sh
	chmod a+x /usr/syno/etc/rc.d/S??synomkthumbd.sh
	# If you don't use Download Station (but e.g. SABnzbd instead):
	chmod a+x /usr/syno/etc/rc.d/S??pgsql.sh

	# echo "Starts some services..."
	/usr/syno/etc/rc.d/S??synoindexd.sh start
	/usr/syno/etc/rc.d/S??synomkflvd.sh start
	/usr/syno/etc/rc.d/S??synomkthumbd.sh start
	# If you don't use Download Station (but e.g. SABnzbd instead):
	/usr/syno/etc/rc.d/S??pgsql.sh start
		
	#@eaDirs for iTunes
	chmod 000 S66fileindexd.sh S66synoindexd.sh S77synomkthumbd.sh S88synomkflvd.sh S99iTunes.sh
	;;
	
        *) echo "Invalid input"
        ;;
esac
