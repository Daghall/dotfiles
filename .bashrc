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
alias vimresume='vim $(git status -s | egrep "^( ?A | M )" | cut -d" " -f3 | xargs)'
alias ls='ls -G'
alias ll='ls -l'
alias la='ls -lA'
alias ip='ipconfig getifaddr en0'
alias ipw='ipconfig getifaddr en1'
alias ipc='ipconfig getifaddr en0 | pbcopy'
alias ipwc='ipconfig getifaddr en1 | pbcopy'
alias dockerrmi='docker images -q | xargs -n 1 docker rmi -f'
alias rc='source ~/.bash_profile'
alias tailf='tail -f'
alias docker-compose='docker-compose --env-file /dev/null'
alias podage='~/scripts/pod-age.sh'
alias ocp='oc project $(oc projects -q | fzf)'
alias nom='echo "😋 Om, nom, nom... 🤤"; npm'
alias twf='test_watch'
alias tw='test_watch -b'
alias yk='~/scripts/yubikey-copy.sh'

function test_watch() {
  clear;
  echo -e "👀 \e[1mWatching... \e[0;30m‟Quis custodiet ipsos custodes?”\e[0m";
  npm t -- $@
  local dirs=$(printf "*.js\n%s\n" $(fd . -t d -E logs -E public -E node_modules));
  fswatch $dirs --event Updated --one-per-batch | xargs -I _ npm t -- $@;
}

# Generate a psuedo-UUID
alias guid='node -p "[8, 4, 4, 4, 12].map(i => (Math.random()).toString(16).slice(-1 * i)).join(\"-\")"'

# Git stuff
alias gg='git grep'
alias gst='git status'
alias gdi='git di'
alias gdis='git dis'
alias gb='git checkout $(git branch -a | sed -e "/origin\/master/d" -e "/\*/d" -e "s#remotes/origin/##" | sort -u | fzf --cycle)'
alias g='cd ~/git/$(ls ~/git | fzf --cycle)'

# Tig
alias tigm='tig --max-parents=3 --graph'
alias tigr='tig reflog'
alias tigs='tig status'

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

# Open pull request on GitHub
function gpr() {
  local branch=$(git rev-parse --abbrev-ref HEAD);
  local repo=$(git config --get remote.origin.url | cut -d":" -f2 | cut -d"." -f1);
  open "https://github.com/$repo/compare/$branch?expand=1";
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

function ppwd () {
  if [[ $# -ne 1 ]]; then
    printf "Usage:\n  ppwd <program-name>\n";
    return;
  fi
  for pid in $(pgrep $1); do
    printf "$pid ";
    lsof -p $pid | grep cwd | grep -o "/.*" | sed "s#$HOME#~#";
  done
}

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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

  local cust_params=$(echo $url | grep 'cust_params=[^\&]*\&' -o)
  echo $url | sed 's/=/ = /g' | tr "&" "\n" | tr "?" "\n"
  if [[ -n "$cust_params" ]]; then
    local perdy_params=$(echo $cust_params | sed -e 's/%3D/ = /g' -e 's/%26/\& - /g')
    echo " - - - - -"
    echo $perdy_params | sed 's/cust_params=/cust_params: \& - /' | tr "&" "\n"
  fi
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
