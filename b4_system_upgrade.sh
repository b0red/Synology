#!/opt/bin/bash
# Creates copys and symlinks of files that changes after a system update
#
# Created 2014-03

clear; echo; echo "Do you want to [B]ackup or [R]estore the files?"

# Settings
BU_PATH="/volume1/my_scripts"
BU_DIR=".UpdateBackups"


read bro
case $bro in 
	[bB] )
	# Backup
	echo "Backing up files..."
	echo "Creating backup filder..."
	mkdir $BU_PATH/$BU_DIR
	echo " $BU_PATH/$BU_DIR created!"
	cp /etc/crontab $BU_PATH/$BU_DIR/crontab 
	cp /root/.profile $BU_PATH/$BU_DIR/.profile
	cp /opt/etc/nail.rc $BU_PATH/$BU_DIR/nail.rc
	cp /etc/ssh/sshrc $BU_PATH/$BU_DIR/sshrc
	##cp /root/.ssh $BU_PATH/$BU_DIR/.ssh/
	cp /root/.tmux.conf $BU_PATH/$BU_DIR/.tmux.conf
	echo "Files copied!"
	;;

	[rR] )
	# Restore
	echo "Restoring files..."
	mv $BU_PATH/$BU_DIR/crontab /etc/crontab; chmod 755 /etc/crontab
	mv $BU_PATH/$BU_DIR/.profile /root/.profile
	mv $BU_PATH/$BU_DIR /root/.tmux.conf
	mv $BU_PATH/$BU_DIR/sshrc /etc/ssh/
	mv $BU_PATH/$BU_DIR/nail.rc /opt/etc/nail.rc
	echo "Files restored!"
	echo "Deleting folder: $BU_PATH/$BU_DIR/"
	rm -rf $BU_PATH/$BU_DIR/; echo "Done!"
	;;

        *) 
	echo "Invalid input"
        echo "Usage: $0 [(B)ackup|(R)estore]"
    ;;
esac

