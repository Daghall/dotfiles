# Source bashrc
. ~/.bashrc

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# bash completion for git (installed by Xcode)
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh

source ~/scripts/git-prompt.sh

# Set PS1
export PS1="[\[\e[33m\]\A\[\e[0m\]] \[\e[33m\]\$(__git_ps1 '·%s· ')\[\033[32m\]\W\[\e[0m\]$ "

PATH=$PATH:~/bin
