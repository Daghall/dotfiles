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

# Allow SSH to execute aliases
shopt -s expand_aliases

# User specific aliases and functions
alias grep='grep --color=auto'
alias less='less -R'
alias vimresume='vim $(git status -s | egrep "^(A  | M )" | cut -d" " -f3 | xargs)'
alias ls='ls -G'
alias ll='ls -l'
alias la='ls -lA'
alias ip='ipconfig getifaddr en0'
alias ipw='ipconfig getifaddr en1'
alias ipc='ipconfig getifaddr en0 | pbcopy'
alias ipwc='ipconfig getifaddr en1 | pbcopy'
alias dockerrmi='docker images -q | xargs -n 1 docker rmi -f'
alias rc='source ~/.bash_profile'

# Git stuff
alias gg='git grep'
alias gst='git status'
alias gdi='git di'
alias gb='git checkout $(git branch -a | sed -e "/origin\/master/d" -e "/\*/d" -e "s#remotes/origin/##" | sort -u | fzf)'
alias g='cd ~/git/$(ls ~/git | fzf)'

# OpenShift Client
alias ocp='oc project $(oc projects -q | fzf)'

# Open commit on GitHub
function co() {
  if [[ $# -ne 1 ]]; then
    printf "usage:\n  co <commit-hash>\n";
    return;
  fi
  local hash=$1;
  local repo=$(git config --get remote.origin.url | cut -d":" -f2 | cut -d"." -f1);
  open "https://github.com/$repo/commit/$hash";
}

# Open on GitHub
function gh() {
  local repo;
  if [[ $1 == "." ]]; then
    repo=$(git config --get remote.origin.url | cut -d":" -f2 | cut -d"." -f1);
  else
    local dir=$(ls ~/git | fzf)
    repo=$(git config --file ~/git/$dir/.git/config --get remote.origin.url | cut -d":" -f2 | cut -d"." -f1);
  fi
  open "https://github.com/$repo";
}

# Open pull request on GitHub
function gpr() {
  local branch=$(git rev-parse --abbrev-ref HEAD);
  local repo=$(git config --get remote.origin.url | cut -d":" -f2 | cut -d"." -f1);
  open "https://github.com/$repo/compare/$branch?expand=1";
}

# Push branch to origin
function gpu() {
  local branch=$(git rev-parse --abbrev-ref HEAD);
  git push --set-upstream origin $branch
}

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

	gawk "BEGIN { printf(\"%s\n\", strftime(\"$format\", $ts)) }"
}

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# Fallback to npm command, if unknown command
command_not_found_handle () {
  npx --no-install $@
}

function cd {
  builtin cd "$@"

  # Execute "nvm use" if ".nvmrc" is found when entering directory
  if [ $? -eq 0 ] && [ -f ".nvmrc" ]; then
    # Use --latest-npm because the NPM version affects package-lock.json, so if we
    # lock the Node.js version with NVM we should try to lock NPM too, and this
    # option sort of does that: "After installing, attempt to upgrade to the latest
    # working npm on the given node version"
    nvm use --latest-npm
  fi

  # Update iTerm2's tab title
  if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
    echo -ne "\033]0;$(pwd | awk -F '/' '{print $NF}' | sed "s/$(whoami)/~/")\007"
  fi
}

# All commands have been installed with the prefix 'g'.
#
# If you really need to use these commands with their normal names, you
# can add a "gnubin" directory to your PATH from your bashrc like:
#
#     PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
#
# Additionally, you can access their man pages with normal names if you add
# the "gnuman" directory to your MANPATH from your bashrc as well:
#
#     MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_CTRL_T_COMMAND='fd --hidden --follow --exclude .git --exclude node_modules'

# Print URL in a more readable way
function urlparams () {
  local url;

  if [[ $# > 0 ]]; then
    url=$1
  else
    url=$(pbpaste)
  fi

  echo $url | sed 's/=/ = /g' | tr "&" "\n" | tr "?" "\n"
}

# Puppeteer
alias killpptr='pgrep -f "puppeteer" | xargs kill -9'

# Mask every other pair of chars
function obscure() {
  read str;
  echo $str | sed -E 's/(..)../\1**/g'
}

# Replace \n with literal newline
function nl2nl () {
  local str;

  # If input is not from stdin, use pastebin
  if [[ -t 0 ]]; then
    str=$(pbpaste)
  else
    read -r str;
  fi
  echo $str | sed 's#\\n#\'$'\n''#g'
}

# Local stuff
source ~/.bashrc_local
