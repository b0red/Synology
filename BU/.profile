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

# Alias'es
alias dir="ls -A"
alias ll="ls -AlFh --color --group-directories-first"
# ll -lAFh | grep "^d" && ll -la | grep "^-" && ls -la | grep -v -E "^d|^-|^total"
# alias ls='ls --color'
alias clr="clear;pwd;ll"
alias cls="clear"
alias ..="cd .."

# New stuff & shortcuts
alias c="clear"
alias h="history"
alias p="pwd"
alias x="exit"

# Get week number
alias week='date +%V'

# Old Prompt
# export PS1='\w$ '
PS1='\u@\h:\w$>';export PS1


# If id command returns zero, you have root access.
if [ $(id -u) -eq 0 ];
	then # you are root, set red colour prompt
    	PS1='\[\e[1;31m\]\u\[\e[m\]\[\e[0;32m\]@\h: \[\e[m\]\[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
  	else # normal
    	# PS1="[\\u@\\h:\\w] $ "
        # PROMPT='\[\e[1;32m\]\u \[\e[m\]\[\e[0;32m\]@\[\e[m\]\[\e[1;32m\]\h: \w \$\[\e[m\] '
        PS1='\[\e[1;32m\]\u\[\e[m\]\[\e[0;32m\]@\h: \[\e[m\]\[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
fi

# Colorize man pages
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
                                        
