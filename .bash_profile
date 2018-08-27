# Source bashrc
. ~/.bashrc

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# bash completion for git (installed by Xcode)
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh

source ~/scripts/git-prompt.sh

# Set PS1
export PS1="[\[\e[33m\]\A\[\e[0m\]] \h \[\e[33m\]\$(__git_ps1 '%s ')\[\033[32m\]\W\[\e[0m\]$ "

PATH=$PATH:~/bin
