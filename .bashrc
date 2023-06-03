# Exports
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim
export PAGER=less
export BAT_THEME=desert
export LS_COLORS="*.readline-colored-completion-prefix=1;31"

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

# Aliases
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
alias tl='tail -f logs/test.log'
alias docker-compose='docker-compose --env-file /dev/null'
alias podage='~/scripts/pod-age.sh'
alias ocp='oc project $(oc projects -q | fzf --prompt "switch project: ")'
alias nom='echo "😋 Om, nom, nom... 🤤"; npm'
alias tw='test_watch npm t -- -b'
alias twf='test_watch npm t'
alias twe='test_watch npm run test:e2e -- -b'
alias yk='~/scripts/yubikey-copy.sh'
alias ep='~/scripts/nord-pool.sh'
alias v='vim'
alias rtf='~/scripts/run-till-fail.sh'
alias runstats='~/scripts/run-stats.sh'

# Use fzf to search for command arguments and replace the command line
function replace_command() {
  case $READLINE_LINE in
    "nr")
      if [[ ! -e package.json ]]; then
        printf "\e[33mpackage.json\e[0m not found\n"
        return
      fi
      READLINE_LINE="npm run $(jq ".scripts | keys | .[]" -r < package.json | fzf --prompt 'npm run ')"
      ;;
    "te")
      if [[ ! -d test/e2e ]]; then
        printf "\e[34mtest/e2e\e[0m not found\n"
        return
      fi
      READLINE_LINE="npm run test:e2e -- -g \"$(git grep Feature test/e2e/ | cut -d\" -f2 | fzf --prompt 'run e2e test: ')\""
      ;;
  esac

  READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\C-n": replace_command'

# Run a command when certain files are uppdated
function test_watch() {
  clear;
  echo -e "👀 \e[1mWatching... \e[0;30m‟Quis custodiet ipsos custodes?”\e[0m";
  "$@"
  local dirs=$(fd . -t d --max-depth 1 -E logs -E public -E node_modules -E tmp);
  fswatch $dirs -e .*\.log$ --event Updated --one-per-batch | xargs -I _ "$@";
}

# Generate a psuedo-UUID
alias guid='node -p "[8, 4, 4, 4, 12].map(i => (Math.random()).toString(16).slice(-1 * i)).join(\"-\")"'

# Git stuff
alias gg='git grep'
alias ggl='GIT_PAGER=less git grep -l'
alias gst='git status'
alias gdi='git diff -- ":!package-lock.json"'
alias gds='git -c delta.side-by-side=true di'
alias gdis='git dis'
alias gdss='git -c delta.side-by-side=true dis'
alias gb='git checkout $(git branch -a | sed -e "/origin\/master/d" -e "/\*/d" -e "s#remotes/origin/##" | sort -u | fzf --cycle  --prompt "checkout branch: ")'
alias g='cd ~/git/$(ls ~/git | fzf --cycle --prompt "select git project: ")'

# Tig
alias tigm='tig --max-parents=3 --graph'
alias tigr='tig reflog'
alias tigs='tig status'

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

# Tar helpers
alias tarball="tar -cvf"
alias tarunball="tar -xvf"
alias tarzball="tar -cvjf"
alias tarzunball="tar -xvjf"

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Print working directories for a given executable
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

# GitHub pull-request TUI
function gpr() {
  local state_template='
    {{- $state := "" -}}
    {{- if .isDraft -}}
      {{- $state = "DRAFT" -}}
    {{- else -}}
      {{- $state = .reviewDecision -}}
      {{- if not $state -}}
          {{- $state = .state -}}
      {{- end -}}
    {{- end -}}'

  local list_template='
    {{- range . -}}
      '$state_template'
      {{- .number -}}{{"\t"}}
      {{- $state -}}{{"\t"}}
      {{- .title}}{{"\t"}}
      {{- .headRefName}}{{"\t"}}
      {{- timeago .updatedAt}}{{"\t"}}
      {{- .mergeable}}{{"\n"}}
    {{- end}}'

  local view_template='
  '$state_template'
    {{- .title -}}{{"\t"}}
    {{- $state -}}
    {{"\t"}}
    {{- .headRefName -}}{{"\t"}}
    {{- if .author.name -}}
      {{- .author.name -}}
    {{- else -}}
      {{- .author.login -}}
    {{- end -}}
    {{"\t"}}
    {{- .mergeable -}}{{"\t"}}
    {{- .body}}'

    local state=$1
    if ! [[ $1 =~ ^(open|closed|merged|all)$ ]]; then
      state="open"
    fi

  FZF_DEFAULT_COMMAND="
    gh pr list \
      --state $state \
      --json number,title,isDraft,mergeable,state,reviewDecision,headRefName,updatedAt \
      --template '$list_template' | \
      awk -F '\t' ' \
      { \
        for (i = 1; i <= NF; ++i) { \
          max[i] = length(\$i) > max[i] ? length(\$i) : max[i]; \
          data[FNR][i] = \$i; \
        } \
      } \
      END { \
        while (NR > 0) { \
          id_color = 32; \
          status = 0; \
          switch (data[NR][2]) { \
            case \"DRAFT\": \
              id_color = 30; \
              status = 30; \
              break; \
            case \"APPROVED\": \
              id_color = 32; \
              status = 32; \
              break; \
            case \"CHANGES_REQUESTED\": \
              id_color = 31; \
              status = 31; \
              break; \
          } \
          printf(\"\\033[%dm%*d  \\033[%dm%s\\033[31m%-*s\\033[0m%-*s  \\033[33m%-*s  \\033[30m%-*s\n\", \
            id_color, \
            max[1], data[NR][1], \
            status, \
            data[NR][2], \
            max[2] + 2 - length(data[NR][2]),
            data[NR][6] == \"CONFLICTING\" ? \"* \" : \"  \", \
            max[3], data[NR][3], \
            max[4], data[NR][4], \
            max[5], data[NR][5] \
          ); \
          --NR; \
        } \
      }' \
    " \
  fzf \
    --ansi \
    --layout reverse-list \
    --tac \
    --exit-0 \
    --header "Viewing $state pull-requests" \
    --bind 'R:execute(gh pr review {1})+reload(eval "$FZF_DEFAULT_COMMAND")' \
    --bind 'X:execute(gh pr close {1})+reload(eval "$FZF_DEFAULT_COMMAND")' \
    --bind 'M:execute(gh pr merge {1})+reload(eval "$FZF_DEFAULT_COMMAND")' \
    --bind 'D:execute(gh pr ready {1})+reload(eval "$FZF_DEFAULT_COMMAND")' \
    --bind 'C:execute(gh pr checkout {1})+abort' \
    --bind 'W:execute-silent(gh pr view {1} -w)' \
    --bind 'j:down' \
    --bind 'k:up' \
    --bind 'q:close' \
    --bind 'Q:abort' \
    --bind 'ctrl-r:reload(eval "$FZF_DEFAULT_COMMAND")' \
    --bind 'ctrl-e:preview-down' \
    --bind 'ctrl-y:preview-up' \
    --bind 'enter:toggle-preview' \
    --disabled \
    --bind='change:clear-query' \
    --prompt '' \
    --no-info \
    --preview-window hidden \
    --preview "gh pr view {1} --json title,isDraft,mergeable,reviewDecision,state,author,body,headRefName --template '$view_template' | \
      awk -F'\t' ' \
        {
          if (FNR == 1) { \
            switch (\$2) { \
              case \"DRAFT\": \
                status = 30; \
                break; \
              case \"APPROVED\": \
                status = 32; \
                break; \
              case \"CHANGES_REQUESTED\": \
                status = 31; \
                break; \
            } \
            printf(\"\\033[33mTitle\\033[0m   %s\n\\033[33mStatus  \\033[%dm%s %s\n\\033[33mBranch  \\033[0m%s\n\\033[33mAuthor  \\033[0m%s\n\n\", \
            \$1, \
            status,
            \$2, \
            \$5 == \"CONFLICTING\" ? \"\\033[31m(conflicting)\" : \"\",
            \$3, \
            \$4); \
        } else { \
          print \$0;
        } \
      } \
    ' | less -R"

    if [[ $? -eq 1 ]]; then
      echo $state | awk '{ printf("No %spull-requests found\n", $1 == "all" ? "" : $1 " ") }'
      return 1
    fi
}

function _gpr_complete() {
  local length=${#COMP_WORDS[@]}
  local last=${COMP_WORDS[-1]}

  if [[ $length -eq 2 ]]; then
    COMPREPLY=($(compgen -W "open closed merged all" -- $last))
  fi
}

complete -F _gpr_complete gpr
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
    echo -ne "\033]0;$(pwd | sed -e "s#/Users/$(whoami)#~#" -e 's#~/git/##')\007"
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
  echo $str | sed -e's#\\n#\'$'\n''#g' -e 's#\\"#"#g'
}

source ~/git/dotfiles/scripts/git-prompt.sh

# Set PS1
export PROMPT_COMMAND=__prompt_command

__prompt_command() {
  local exit_code=$?
  local exit_code_string

  if [[ $exit_code -ne 0 ]]; then
    exit_code_string="\[\e[31m\]·${exit_code}·\[\e[0m\] "
  fi
  PS1="[\[\e[33m\]\A\[\e[0m\]] $exit_code_string\[\e[33m\]\$(__git_ps1 '·%s· ')\[\e[32m\]\W\[\e[0m\]\$ "
}

# Functions
source ~/scripts/bash_functions.sh

# Local stuff
source ~/.bashrc_local
