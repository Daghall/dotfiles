# Exports
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim
export PAGER=less
export BAT_THEME=daghall
export LS_COLORS="*.readline-colored-completion-prefix=1;31"
export TLDR_AUTO_UPDATE_DISABLED=1

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
alias vimresume='eval vim $(git status -s | egrep "^( ?A |[ M]M )" | awk '\''{ print $NF }'\'' | xargs)'
alias vimqf='vim -q <($(history -p !!)) +cw'
alias todo='git diff | grep ^\+.*TODO | sed -E -e '\''s/  +//'\'' -e '\''s#^\+(// )?##'\'' -e '\''s#TODO:#\x1b[0m\x1b[32m&\x1b[34m#'\'''
alias ls='ls -G'
alias ll='ls -l'
alias la='ls -lA'
alias ip='ipconfig getifaddr en0'
alias ipw='ipconfig getifaddr en1'
alias ipc='ipconfig getifaddr en0 | pbcopy'
alias ipwc='ipconfig getifaddr en1 | pbcopy'
alias dockerrmi='docker images -q | xargs -n 1 docker rmi -f'
alias kk='kill -KILL'
alias rc='source ~/.bash_profile'
alias tailf='tail -f'
alias tl='tail -f logs/test.log'
alias docker-compose='docker-compose --env-file /dev/null'
alias nom='echo "😋 Om, nom, nom... 🤤"; npm'
alias tw='test_watch npm t -- -b'
alias twf='test_watch npm t'
alias twe='test_watch npm run test:e2e -- -b'
alias yk='~/scripts/yubikey-copy.sh'
alias ep='~/scripts/elpriser.js'
alias tri='for dir in $(find terraform -name "*.hcl" | xargs dirname); do rm -rf $dir/.terraform; terraform -chdir=$dir init; done'
alias rtf='~/scripts/run-till-fail.sh'
alias runstats='~/scripts/run-stats.sh'
alias reset='\reset; s'
alias r='reset'
alias glow='~/scripts/glow.sh'
alias strip_colors='sed -E '\''s/\x1b\[[0-9]{1,3}(;[0-9]{1,3})*m//g'\'''
alias disp_home='displayplacer "id:A80222CB-3967-759E-4FE4-1C33EBAD8040 res:2560x1440 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0" "id:111A152E-C39C-C6F7-B8F8-7EEFADE8E03A res:1440x900 color_depth:8 scaling:on origin:(2560,540) degree:0"'
alias disp_work='displayplacer "id:1BA0828D-9B05-4E07-31EA-3B78385DD065 res:2560x1440 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0" "id:111A152E-C39C-C6F7-B8F8-7EEFADE8E03A res:1440x900 color_depth:8 scaling:on origin:(-1440,540) degree:0"'
alias pb64='awk '\''{ printf("%s%.*s", $0, length($0) % 4, "==") }'\'''
alias ivanti='ps ax | grep Ivanti | awk '\''{print $1}'\'' | sudo xargs kill -KILL'
alias sudo='sudo '

# Vim alias that handles <filename>:<line>:<column>
function v() {
  local file="$@"

  if [[ $file =~ ":" ]]; then
    file=$(sed -E 's/:([^:]+)(:[^:]+)?/ +:\1/' <<< "$@")
  fi

  # Evaluate the filename, to make it prettier when showing job title
  eval vim $file
}

# Use fzf to search for command arguments and replace the command line
function replace_command() {
  case $READLINE_LINE in
    "")
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
      local suite=$(grep -r Feature test/e2e/ | cut -d\" -f2 | fzf --prompt 'run e2e test: ')
      if [[ "$suite" != "" ]]; then
        READLINE_LINE="npm run test:e2e -- -g \"Feature: $suite Scenario:\""
      else
        READLINE_LINE="npm run test:e2e -- -g \"\""
      fi
      ;;
  esac

  READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\C-n": replace_command'

# Run tests via `make` or `npm`
function t() {
  if [[ -e Makefile ]]; then
    make test
  else
    npm test
  fi
}

# Run a command when certain files are updated
function test_watch() {
  clear;
  echo -e "👀 \e[1mWatching... \e[0;30m‟Quis custodiet ipsos custodes?”\e[0m";
  "$@"
  local dirs=$(fd . -t d --max-depth 1 -E logs -E public -E node_modules -E tmp -E npm-review.dSYM/);
  fswatch index.js $dirs -e .*\.log$ --event Updated --one-per-batch | xargs -I _ "$@";
}

# Release message
function dm() {
  local project=$(basename $(pwd))
  local message=$(pbpaste | sed -E -e 's/[]/\n– /g' -e 's/^/– /')
  printf "Team: Core GTV\nProduct: %s\n%s" "$project" "$message" | pbcopy
}

# Generate a UUID
alias guid='node -p "require(\"crypto\").randomUUID()"'

# GIT STUFF

# Git grep pattern as a single string, parameters in arbitrary order
function gg() {
  local flags=""
  local pattern=""
  local pager="delta"
  local dir="."

  for word in $@; do
    if [[ $word == -* ]]; then
      flags="$flags $word"

      # `delta` can't parse list output correctly. Since the only output is
      # filenames and line numbers, `less` is a sufficient pager
      if [[ $word == "-l" ]]; then
        pager="less"
      fi
    else
      if [[ -e $word ]]; then
        dir="$dir $word"
      else
        pattern="$pattern $word"
      fi
    fi
  done

  GIT_PAGER=$pager git grep $flags "${pattern:1}" ${dir:2}
}

alias gst='git status -sb'
alias gdi='git diff -w -- ":!package-lock.json"'
alias gdiw='git diff -- ":!package-lock.json"'
alias gds='git -c delta.side-by-side=true di'
alias gdis='git dis'
alias gdss='git -c delta.side-by-side=true dis'
alias gic='git clean -n | awk '\''{ print $NF }'\'' | fzf --multi --reverse --height=-1 | xargs rm'

# Change git branch with fuzzy finding
function gb() {
  local branch=$(
    git branch -a | \
    sed -E \
      -e "/\*/d"  \
      -e "#origin/master#d"  \
      -e "s#remotes/(origin|upstream)/##"  \
      -e "/HEAD/d" | \
    sort -u | \
    awk '{ print $1 }'| \
    fzf --cycle  --prompt "checkout branch: "
  );
  git checkout $branch
}

# Change directory to git repository
function g() {
  local arg="$1"
  cd ~/git/$(ls ~/git | \
    fzf \
      --cycle \
      --prompt "select git project: "\
      --select-1 \
      --query="$1"
  )
}

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
  local repo=$(git_branch);
  open "https://github.com/$repo/commit/$hash";
}

# Open branch on GitHub
function cb() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local repo=$(git_branch)
  open "https://github.com/$repo/tree/$branch";
}

# Print git branch
function git_branch() {
  git config --get remote.origin.url | cut -d":" -f2 | cut -d"." -f1
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


# Print working directories for a given executable, and send it a signal
function kpwd () {
  if [[ $# -ne 1 ]]; then
    printf "Usage:\n  kpwd <program-name>\n";
    return;
  fi
  pid=$(ppwd $1 | \
    fzf \
      --bind 'enter:become(echo {1})' \
      --cycle \
  );
  signal=$(kill -l | \
    sed -e 's/\t/\n/g' | \
    fzf \
      --header 'Select signal' | \
    grep -Eo '\d+' \
  );

  echo kill -$signal $pid;
  kill -$signal $pid;
}


# GitHub pull-request TUI
function gpr() {
  local git_origin=$(git config --local remote.origin.url | sed -e 's/[^:]*://' -e 's/\.git$//' | tr -d "\n")

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
    {{- if len .labels -}}
      {{- range $i, $val := .labels -}}
        {{- if $i}} {{end -}}
       [48;2;0x{{ slice .color 0 2 }};0x{{ slice .color 2 4 }};0x{{ slice .color 4 6 }}m {{- .name -}} [0m
      {{- end -}}
    {{- else -}}
      –
    {{- end -}}{{"\t"}}
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
      gawk -F '\t' ' \
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
    --preview "gh pr view {1} --json title,isDraft,mergeable,reviewDecision,state,author,labels,body,headRefName --template '$view_template' | \
      sed 's/\r//g' | \
      gawk -F'\t' ' \
        function parse_hex(input) { \
          while (match(tolower(input), /0x[0-9a-f][0-9a-f]/)) { \
            hex = substr(input, RSTART, RLENGTH); \
            sub(hex, strtonum(hex), input) \
          } \
          return input; \
        } \
        { \
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
            printf(\"\\033[33mTitle\\033[0m   %s\n\\033[33mStatus  \\033[%dm%s %s\n\\033[33mBranch  \\033[0m%s\n\\033[33mAuthor  \\033[0m%s\n\\033[33mLabels  \\033[0m%s\n\n\", \
              \$1, \
              status,
              \$2, \
              \$5 == \"CONFLICTING\" ? \"\\033[31m(conflicting)\" : \"\",
              \$3, \
              \$4, \
              parse_hex(\$6) \
            ); \
          body = \$7; \
        } else { \
          body = body \"\n\" \$0; \
        } \
      } \
      END { \
        gsub(/\047/, \"\047\042\047\042\047\", body); \
        body = \"~/scripts/glow.sh <<< \047\" body \"\047\"; \
        comments = \"~/scripts/github-pr-comments.js $git_origin {1}\";
        system(body); \
        printf(\"\n\033[33mComments\033[0m\n\n\"); \
        system(comments); \
      } \
    ' | less -R"

    if [[ $? -eq 1 ]]; then
      echo $state | awk '{ printf("No %spull-requests found\n", $1 == "all" ? "" : $1 " ") }'
      return 1
    fi
}

function dkr() {
  FZF_DEFAULT_COMMAND="docker container list --all --format 'table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.Command}}\t{{.RunningFor}}\t{{.Status}}'" \
    fzf \
      --reverse \
      --prompt '' \
      --no-info \
      --disabled \
      --header-lines 1 \
      --nth 1 \
      --delimiter="  +" \
      --bind='change:clear-query' \
      --bind 'j:down' \
      --bind 'k:up' \
      --bind 'q:close' \
      --bind 'ctrl-s:execute-silent(docker start {1})+reload(eval "$FZF_DEFAULT_COMMAND")' \
      --bind 'ctrl-x:execute-silent(docker stop {1})+reload(eval "$FZF_DEFAULT_COMMAND")' \
      --bind 'ctrl-e:become(docker container exec -it {1} sh)' \
      --bind 'ctrl-r:+reload(eval "$FZF_DEFAULT_COMMAND")'
}

function _gpr_complete() {
  local length=${#COMP_WORDS[@]}
  local last=${COMP_WORDS[-1]}

  if [[ $length -eq 2 ]]; then
    COMPREPLY=($(compgen -W "open closed merged all" -- $last))
  fi
}

complete -F _gpr_complete gpr


# Smooth handling of GitHub gists
function gists() {
  gh gist list -L 1000 | \
    gawk -F'\t' '{ \
      sub("T.*", "", $5);\
      printf("\033[33m%s\033[0m\t%s\t\033[%dm%s\033[30m\t%s\t%s\n",
        $2, \
        $3, \
        ($4 == "secret" ? 31 : 32), \
        $4, \
        $5,
        $1\
      ); \
      ;
    }' | \
    sort -t'	' -k4  | \
    column -t -s '	' | \
    fzf \
      --ansi \
      --cycle \
      --delimiter '  ' \
      --nth 1 \
      --tac \
      --bind 'enter:become(gh gist view -w {-1})' \
      --bind 'ctrl-e:become(gh gist edit {-1})' \
      --bind 'ctrl-p:preview(gh gist view {-1} | bat --color=always -p -l $(sed "s/[^.]*\.//" <<< {1} | awk '\''{ if (length($0) > 4){ print "sh"} else { print $0 } }'\''))' \
      --bind 'ctrl-c:close' \
  ;
}

# Put the current and previous jobs last
function _sort_jobs {
  awk '
  {
    if ($1 ~ /-$/) {
      prev = $0
    } else if ($1 ~ /\+$/) {
      curr = $0
    } else {
      a[length(a) +1] = $0
    }
  }

  END {
    while (i++ < length(a)) {
      print a[i]
    };
    if (length(prev) > 0) {
      printf("%s\n", prev)
    }
    if (length(curr) > 0) {
      printf("%s\n", curr)
    }
  }' -
}

# List, fuzzyfind and bring background jobs to foreground
function list_jobs() {
  local job_line=$(jobs | _sort_jobs | fzf -0 -1 --tac)
  local exit_code=$?
  local job_id=$(sed -E "s/\[([0-9]+).*/\1/" <<< $job_line)

  if [[ "$job_id" -eq "" && $exit_code -eq 0 ]]; then
    echo "No background jobs"
    return 0
  fi

  if [[ $exit_code -eq 0 ]]; then
    eval fg $job_id
  else
    return exit_code
  fi
}
bind -x '"\C-f": list_jobs'

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

export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="~/bin:/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";


# Fuzzy finder
 eval "$(fzf --bash)"
export FZF_CTRL_T_COMMAND='fd --hidden --follow --exclude .git --exclude node_modules'

# Print URL in a more readable way
function urlparams () {
  local url;

  if [[ $# > 0 ]]; then
    url=$1
  else
    url=$(pbpaste)
  fi

  local cust_params=$(echo $url | grep -E 'cust_params=[^\&]*\&?' -o)

  echo -e "[36m$url" | \
    sed -E \
      -e 's/[?&]/\n[32m/g' \
      -e 's/=/[34m = [0m/g'

  if [[ -n "$cust_params" ]]; then
    local perdy_params=$(echo $cust_params | sed -e 's/%3D/ = /g' -e 's/%26/\& - /g')
    echo " - - - - -"
    echo $perdy_params | \
      sed 's/cust_params=/cust_params: \& - /' | \
      tr "&" "\n" | \
      sed -E 's/([a-z0-9_]*) =/[32m\1 [34m=[0m/i'
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
