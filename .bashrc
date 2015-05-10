# .bashrc

# Exports
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim
export PAGER=less

# Remove the annoying echoing of ^C when hitting CTRL-C
if [[ $- == *i* ]]
then
	stty -echoctl
fi
alias s='stty -echoctl'

# Screen colors
force_color_prompt=yes
PS1="[\[\e[33m\]\A\[\e[0m\]] \h \[\e[33m\]\$(__git_ps1 '%s ')\[\033[32m\]\W\[\e[0m\]$ "

# Allow SSH to execute aliases
shopt -s expand_aliases

# User specific aliases and functions
alias grep='grep --color=auto'
alias less='less -R'
alias vi='vim'
alias vimresume='vim -p $(git status -s | egrep "^(A  | M )" | cut -d" " -f3 | xargs)'
alias stripcolors='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias g='grep -r'
alias cal='cal -m'
alias d='display'

# Git stuff
alias gup='git pull'
alias gco='git checkout'
alias gst='git status'
alias gdi='git di'
alias gci='git commit'
alias grevert='echo "git reset --hard <branch> path/file"'
alias gg='git grep'

# Tar helpers
alias tarball="tar -cvf"
alias tarunball="tar -xvf"
alias tarzball="tar -cvjf"
alias tarzunball="tar -xvjf"

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Function: helper function for the "find" command, with grep-like param order
function f() {
	if [[ $2 == "" ]]; then
		find . -name $1
	else
		find $2 -name $1
	fi
}

# Function: UNIX timestamp to date
function ts2date() {
	local format="%F %R"

	case $# in
		2 )
			format=$2 ;&
		1 )
			ts=$1 ;;
		0 )
			read ts ;;
	esac

	awk "BEGIN { printf(\"%s\n\", strftime(\"$format\", $ts)) }"
}
