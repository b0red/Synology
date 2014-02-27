#!/opt/bin/bash
#
datetime=$(date +%Y%m%d%H%M%S)

lowercase(){
        echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

####################################################################
# Get System Info
####################################################################
shootProfile(){
        OS=`lowercase \`uname\``
        KERNEL=`uname -r`
        MACH=`uname -m`

        if [ "${OS}" == "cygwin_nt-6.1" ]  ; then
                OS=windows
        elif [ "${OS}" == "darwin" ]  ; then
                OS=mac
        else
                OS=`uname`
                if [ "${OS}" = "SunOS" ] ; then
                        OS=Solaris
                        ARCH=`uname -p`
                        OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
                elif [ "${OS}" = "AIX" ] ; then
                        OSSTR="${OS} `oslevel` (`oslevel -r`)"
                elif [ "${OS}" = "Linux" ] ; then
                        if [ -f /etc/redhat-release ] ; then
                                DistroBasedOn='RedHat'
                                DIST=`cat /etc/redhat-release |sed s/\ release.*//`
                                PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
                                REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
                        elif [ -f /etc/SuSE-release ] ; then
                                DistroBasedOn='SuSe'
                                PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
                                REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
                        elif [ -f /etc/mandrake-release ] ; then
                                DistroBasedOn='Mandrake'
                                PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
                                REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
                        elif [ -f /etc/debian_version ] ; then
                                DistroBasedOn='Debian'
                                if [ -f /etc/lsb-release ] ; then
                                        DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
                                        PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
                                        REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
                                    fi
                        fi
                        if [ -f /etc/UnitedLinux-release ] ; then
                                DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
                        fi
                        OS=`lowercase $OS`
                        DistroBasedOn=`lowercase $DistroBasedOn`
                         readonly OS
                         DIST=`lowercase $DIST`
			 readonly DIST
                         readonly readonly DistroBasedOn
                         readonly PSUEDONAME
                         readonly REV
                         readonly KERNEL
                         readonly MACH
                fi

        fi
}
shootProfile
if test "$1" = "P"
then
 clear
 echo "OS: $OS"
 echo "DIST: $DIST"
 echo "PSUEDONAME: $PSUEDONAME"
 echo "REV: $REV"
 echo "DistroBasedOn: $DistroBasedOn"
 echo "KERNEL: $KERNEL"
 echo "MACH: $MACH"
 echo "========"
fi


case $OS in
  linux)
    # if user is not root, pass all commands via sudo #
    if [ $UID -ne 0 ]; then
      alias reboot='sudo reboot'
      alias update='sudo apt-get upgrade'
    fi
    #distro=$(lsb_release -si)
    case $DIST in
      ubuntu)
	alias install='sudo apt-get install'
	alias remove='sudo apt-get remove'
	alias update='sudo apt-get update'
	alias upgrade='sudo apt-get upgrade'
	alias uu='sudo apt-get update && sudo apt-get upgrade'
	alias purge='sudo apt-get purge'
	alias acs='apt-cache search'
	alias ls="ls -alF --color=auto --group-directories-first"
        ;;
      rhel|centos|fedora)
	  alias update='yum update'	
	  alias updatey='yum -y update'
	  ;;
	*)
        echo "Sorry, Linux distribution '$DIST' is not supported"
        exit 1
        ;;
    esac
    ;;
  freebsd) echo=FreeBSD
      alias ls='ls -alFGh -D "%F %H:%M"'
      # Reinstall
      alias reinstall="make deinstall && make reinstall clean"
      alias install="make install clean"
      # Version function
	function vv() {
	  portmaster -L --index-only| egrep "(ew|ort) version|total install"
	}
    ;;
  windows) echo=windows
	export SHELLOPTS
 	set -o igncr
	unalias nano
	alias ls="ls -laCFo --color"
	alias l="ls -a --color"
	;;
  darwin) echo=Mac
      alias ls="ls -h"
    ;;
  SunOS) echo=Solaris
    ;;
  aix) echo=AIX
    ;;
  *) echo "Sorry, OS '$OS' is not supported"
    ;;
esac
