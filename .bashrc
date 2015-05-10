# .bashrc

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Remove the annoying echoing of ^C when hitting CTRL-C
if [[ $- == *i* ]]
then
	stty -echoctl
fi

# Screen colors
force_color_prompt=yes
PS1="[\[\e[33m\]\A\[\e[0m\]] \h \[\e[33m\]\$(__git_ps1 '%s ')\[\033[32m\]\W\[\e[0m\]$ "

# Allow SSH to execute aliases
shopt -s expand_aliases

# User specific aliases and functions
alias rmake='make -C `pwd | cut -d \/ -f1-4` --no-print-directory'
alias srcdir='pwd | cut -d \/ -f1-4'
alias rcd='cd $(srcdir)'
alias rein='rmake rebuild-asearch'
alias upd='rmake update-aindex'
alias load='make db-restore-fads-and-stores && make rim'
alias admins='rmake regress-admins'
alias rr='make rc ri rd'
alias rinfo='rmake rinfo'
alias cssf='rmake rw-css && fg'
alias jsf='rmake rw-js && fg'
alias rbf='rmake rb && fg'
alias remlf='rmake reml && fg'
alias remtf='rmake remt && fg'
alias reptf='rmake rept && fg'
alias w='make rw'
alias t='make remt'
alias b='make rb'
alias css='rmake rw-css'
alias js='rmake rw-js'
alias rb='rmake rb'
alias reml='rmake reml'
alias rept='rmake rept'
alias remt='rmake remt'
alias remod='rmake remod'
alias sup='svn up'
alias grep='grep --color=auto'
alias less='less -R'
alias wrpm='./scripts/which_rpm.bash'
alias vi='vim'
alias vimresume='vim -p $(git status -s | egrep "^(A  | M )" | cut -d" " -f3 | xargs)'
#alias vimresume='vim -p $(bzr added && bzr modified)'
alias allup='ls ~/src/ | while read branch; do echo -e "\\033[1;35mUpdating $branch\\033[39;0m" && bzr up ~/src/$branch; done'
#alias bzr='PAGER="" bzr'
alias frp='for file in $(find build/regress/apps/ -name "*.php"); do find php/ -name $(basename $file) | xargs cp -t $(dirname $file); done'
alias frpi='for file in $(find build/regress/include -name "*.php"); do find php/ -name $(basename $file) | xargs cp -t $(dirname $file); done'
alias tl='less build/regress/logs/trans.log'
alias ctl=':> build/regress/logs/trans.log'
alias ftl='tail -f build/regress/logs/trans.log'
alias clearcores='find . -name core.* | xargs rm'
alias transgdb=' ls -lt build/regress/bin/core.* && gdb build/regress/bin/trans $( ls -lt build/regress/bin/core.* | head -1 | cut -d " " -f 9)'
alias fixcars='php -c build/regress/conf/ scripts/migrate/to_2.0/apply_store_carfax_data.php && make rebuild-asearch'
alias transpose='awk -f ~/.scripts/transpose.awk'
alias vf='curl $(\grep vf build/regress/logs/mail.txt) --silent | grep "<title>" -A 2 | tail -1'
alias stripcolors='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias bf='. util/blocket_functions'
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
alias gds='~/.scripts/diff_stats.sh'

# Git env
#export GIT_DIR=~/blocket/.git
#export GIT_WORK_TREE=~/blocket/

alias r='make reinstall-scripts'
alias c='make campsearch-regress-stop; make campsearch-regress-start'
alias s='stty -echoctl'

alias reglog='ls -1tr out/logs/ | tail -1'
alias lesslog='less $(reglog)'
alias greplog='grep -i error "out/logs/"$(reglog)'
alias taillog='watch -n 0.1 tail -30 "out/logs/\$(ls -1tr out/logs/ | tail -1)"'


# Test stuff
alias transtest='make rc ri ; cd daemons/trans ; make rd rdo'
alias webtest='make rc ri && cd regress/final && make rd rdo SELENIUM_PASS=y'
alias seltest='make rc ri && cd regress/final && make rd rs-load && make rdo REGRESS_SKIPTO=selenium-start SELENIUM_PASS=y'
alias selprep='make rc ri && cd regress/final && make rd rs-load selenium-start'
alias pic='display $(echo $(srcdir)/out/testresult/$(ls -1t $(srcdir)/out/testresult/ | \grep "\.png$" | head -1)) &'
alias pic2='firefox $(echo $(srcdir)/out/testresult/$(ls -1t $(srcdir)/out/testresult/ | \grep "\.png$" | head -1)) &'

#alias blink='find ~ -maxdepth 1 -type l | xargs rm 2>/dev/null; for branch in $(ls ~/src); do ln -s -f ~/src/$branch ~/$branch; done'
alias branch='git --git-dir=/home/markus/blocket/.git --work-tree=/home/markus/blocket/ branch -l | grep "*" | cut -d" " -f2'
alias branches='for host in 29 31 32 33 37 38; do printf "dev$host: " && ssh 192.168.4.$host "branch"; done'
alias cdb='cd ~/blocket && bf'
alias qa="ssh s.blcoket.se -lladmin"
alias qa_ctl="./scripts/qa/qa_ctl"
alias tarball="tar -cvf"
alias tarunball="tar -xvf"
alias tarzball="tar -cvjf"
alias tarzunball="tar -xvjf"

# Debug


export EDITOR=vim

export PGHOST=/dev/shm/regress-$USER/pgsql0/data
export PGDATABASE=blocketdb

export PAGER=less

export MP_EMAIL=markus@blocket.se

# Proxy
#export http_proxy=http://192.168.4.151:3128

# Copy/paste from Makefiles support
export TOPDIR=~/blocket

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

function f() {
	if [[ $2 == "" ]]; then
		find . -name $1
	else
		find $2 -name $1
	fi
}

function mp_activate() {
	local email=$1

	if [[ $email == "" ]]; then
		email="markus.daghall@blocket.se"
	fi

	curl -k -L --silent $(cat build/regress/logs/mail.$email.txt |grep -A 2 "Aktivera ditt konto"|cut -d ":" -f2-|sed -e "s/3D//g"|sed -e "s/ //"|awk '{sub(/=$/,"")sub(/=@/,"@");sub(/=3D/,"=");printf $0} END{print ""}') | grep "Kontot har redan aktiverats"
}

function gload () {
	ssh -f -X 192.168.4.29 "xload -scale 5 -hl red -jumpscroll 1 -update 1 -geometry 440x346+0+0" #730 for fullscreen
	ssh -f -X 192.168.4.31 "xload -scale 5 -hl red -jumpscroll 1 -update 1 -geometry 440x346+455+0"
	ssh -f -X 192.168.4.32 "xload -scale 5 -hl red -jumpscroll 1 -update 1 -geometry 440x346+910+0"
	ssh -f -X 192.168.4.33 "xload -scale 5 -hl red -jumpscroll 1 -update 1 -geometry 440x346+0+385"
	ssh -f -X 192.168.4.37 "xload -scale 5 -hl red -jumpscroll 1 -update 1 -geometry 440x346+455+385"
	ssh -f -X 192.168.4.38 "xload -scale 5 -hl red -jumpscroll 1 -update 1 -geometry 440x346+910+385"
}

function qa_push() {
	make rpm-qa && ./scripts/qa/qa_ctl --update --name $1
}

function pushrc() {
	if [[ ~ != $(pwd) ]]; then
		echo "Aborting: not in home dir!"
		return
	fi

	local current=$(hostname | grep -o "[0-9]*")

	for host in 29 31 32 33 37 38; do
		if [[ $host != $current ]]; then
			echo "Pushing scripts and settings to dev$host"
			ssh dev$host 'rm -rf .scripts .vim';
			scp -r ~/.bash_profile .bashrc .vimrc .vim .gitconfig .scripts diffs playground 192.168.4.$host: 1>/dev/null;
		fi
	done

	# Paranoia
	cp -r .bash_profile .bashrc .vimrc .vim .gitconfig .scripts diffs playground .backup/

	. ~/.bashrc
}

function pake() {
	for target in $@;
	do
		make p3-$target;
	done
}

function seldisp() {
	if [[ -z $SELENIUM_DISPLAY ]]; then
		export SELENIUM_DISPLAY=$DISPLAY;
		echo "Set selenium display to $SELENIUM_DISPLAY";
	else
		unset SELENIUM_DISPLAY;
		echo "Selenium display unset";
	fi
}

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

function mod_image() {

	printf "" > build/regress/www/mod_images.html

	for size in $(grep "^\*\.\*\.mod_image\.type" conf/bconf/mod_image.bconf | cut -d "." -f 5 | sort -u); do
		printf "<b>%s</b>:<br><img src=\"http://%s.blocket.bin:%d/%s/%0.2s/%s.jpg\"><br><br>\n" $size $(hostname | cut -d"." -f1) $(genport 1) $size $1 $1 >> build/regress/www/mod_images.html;
	done

	printf "http://%s.blocket.bin:%d/mod_images.html\n" $(hostname | cut -d"." -f1) $(genport 8)
}
