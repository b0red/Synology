#!/opt/bin/bash
# Creates copys and symlinks of files that usually changes after a system update
#
# Created 2014-03
# Updated 2014-05

clear; echo; echo "Do you want to [B]ackup or [R]estore the files?"

# Settings
BU_PATH="/volume1/my_scripts"
BU_DIR="BU"
NEWPATH=$BU_PATH/$BU_DIR
FILE=B4U-Backup
DBPATH=/Machines/Synology/Backups

# Include variables
source $BU_PATH/variables.sh
# Inclide email_variables
source $BU_PATH/email_variables.sh

read bro
case $bro in
	[bB] )
	# Backup
	if [ ! -d "$NEWPATH" ]; then
		# Control will enter here if $DIRECTORY doesn't exist.
		echo "Creating backup folder..."
		mkdir $NEWPATH; echo "$NEWPATH created!"
	  fi
	echo "Backing up files..."
		cp /etc/crontab $NEWPATH/crontab								# crontab
		cp /root/.profile $NEWPATH/.profile								# .profile in root
		cp /etc/rc.local $NEWPATH/rc.local								# rc.local
		cp /opt/etc/nail.rc $NEWPATH/nail.rc							# nail config
		cp /etc/ssh/sshrc  $NEWPATH/sshrc								# mail on login
		cp /root/.tmux.conf $NEWPATH/.tmux.conf							# tmux.conf
		cp /opt/etc/nanorc $NEWPATH/nanorc								# nanorc
		cp /usr/local/sickbeard/var/config.ini $NEWPATH/SB_Config.ini	# SB config
		cp /usr/local/sabnzbd/var/config.ini $NEWPATH/SAB_Config.ini	# SABnzbd
		cp /volume2/@appstore/transmission/var/settings.json $NEWPATH/settins.json #Transmission
		cp /volume1/@appstore/sabnzbd/app/config $NEWPATH/SABnzbd_config
		cp /volume1/@appstore/couchpotatoserver/var/settings.conf $NEWPATH/CP_settings.conf
		cp /opt/etc/nail.rc $NEWPATH/nail.rc							# Mail settings for nail
		cp /root/.dropbox_uploader $NEWPATH/.dropbox_uploader			# Dropbox settings
		echo  $NEWPATH/$FILE-$DATE.zip
		if zip -r $NEWPATH/$FILE-$DATE.zip $NEWPATH/ -x bt_level* *.zip ;then
				droptobox upload $NEWPATH/$FILE-$DATE.zip $DBPATH
				echo "Backup" | /opt/bin/nail -s "$FILE-$DATE.zip till dropbox @$NODE" -a  $NEWPATH/$FILE-$DATE.zip $EMAIL_P
			else
				echo "Nothing done!"
		fi
	echo "Files copied and sent!"
	# echo "Deleting zipfile: $FILE-$DATE.zip"
	# rm -rf  $NEWPATH/$FILE-$DATE.zip
	;;

	[rR] )
	# Restore files to original places
	echo "Restoring files..."
		mv $NEWPATH/crontab /etc/crontab; chmod 755 /etc/crontab
		mv $NEWPATH/.profile /root/.profile
		mv $NEWPATH/rc.local /etc/rc.local
		mv $NEWPATH/nail.rc /opt/etc/nail.rc
		mv $NEWPATH/sshrc /etc/ssh/sshrc
		mv $NEWPATH/root/.tmux.conf /root/.tmux.conf
		mv $NEWPATH/nanorc /opt/etc/nanorc
		mv $NEWPATH/SB_Config.ini /usr/local/sickbeard/var/config.ini
		mv $NEWPATH/SAB_Config.ini /usr/local/sabnzbd/var/config.ini
		mv $NEWPATH/settins.json /volume2/@appstore/transmission/var/settings.json
		mv $NEWPATH/SABnzbd_config /volume1/@appstore/sabnzbd/app/config
		mv $NEWPATH/CP_settings.conf /volume1/@appstore/couchpotatoserver/var/settings.conf
		mv $NEWPATH/nail.rc /opt/etc/nail.rc
		mv $NEWPATH/.dropbox_uploader /root/.dropbox_uploader
		echo "Files restored!"
	read -p "Do you want do delete backups after restore? " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]];then
		# do dangerous stuff
    	rm -rf $NEWPATH/* ; echo "Done!"
    fi
	;;

        *)
	echo "Invalid input"
    echo "Usage: $0 [(B)ackup|(R)estore]"
    	;;
esac
