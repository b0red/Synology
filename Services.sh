#!/opt/bin/bash
# Bash Menu Script Example

clear

PS3='Please enter your choice for service to restart: '
options=("Apache (1)" "Appletalk (2)" "Cron (3)" "Ftp (4)" "index (5)"\
"itunes (6)" "mysql (7)" "nfs (8)" "SSH(9)" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1")
            echo "you chose choice 1"
            /usr/syno/etc/rc.d/S97apache-user.sh restart
	   ;;
        "Option 2")
           echo "you chose choice 2"
           /usr/syno/etc/rc.d/S81atalk.sh restart 
	   ;;
	"Option 3")
           echo "you chose choice 3"
           /usr/syno/etc/rc.d/S04crond.sh stop
	   /usr/syno/etc/rc.d/S04crond.sh start
	   ;;
	"Option 4")
            echo "you chose choice 4"
           /usr/syno/etc/rc.d/S99ftpd.sh restart
	    ;;
	"Option 5")
            echo "you chose choice 5"
           /usr/syno/etc/rc.d/S66synoindexd.sh restart
	   ;;
	"Option 6")
            echo "you chose choice 6"
            /usr/syno/etc/rc.d/S99itunes.sh restart
	    ;;
	"Option 7")
            echo "you chose choice 7"
           /usr/syno/etc/rc.d/S21mysql.sh restart
           ;;
	"Option 8")
            echo "you chose choice 8"
            /usr/syno/etc/rc.d/S83nfsd.sh restart
	    ;;
	"Option 9")
            echo "you chose choice 9"
            /usr/syno/etc.defaults/rc.d/S95sshd.sh restart
	    ;;
	"Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
