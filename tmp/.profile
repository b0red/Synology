umask 022

PATH=/opt/bin:/opt/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin
export PATH

#This fixes the backspace when telnetting in.
#if [ "$TERM" != "linux" ]; then
#        stty erase
#fi
export EDITOR=nano 

# add new for Midnight Commander
export TERMINFO=/opt/share/terminfo
export TERM=xterm
alias mc="mc -c"

HOME=/root
export HOME

TERM=${TERM:-cons25}
export TERM

PAGER=more
export PAGER

PS1="`hostname`> "

alias dir="ls -al"
alias ll="ls -la"


alias ls='ls --color'
export PS1='\w$ '
alias ls='ls --color'
export PS1='\w$ '
