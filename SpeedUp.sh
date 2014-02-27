#!/opt/bin/bash
#
# Script for speeding up the NAS

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
	;;
	
        *) echo "Invalid input"
        ;;
esac
