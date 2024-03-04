# Source bashrc
. ~/.bashrc

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

complete -C /usr/local/bin/terraform terraform

export CLOUDSDK_PYTHON=/usr/local/bin/python3.10

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/markus.daghall/google-cloud-sdk/path.bash.inc' ]; then . '/Users/markus.daghall/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/markus.daghall/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/markus.daghall/google-cloud-sdk/completion.bash.inc'; fi

# General bash completions (brew install bash-completion@2)
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Completion for git/tig
[[ -r "/opt/homebrew/etc/bash_completion.d/git-completion.bash" ]] && . "/opt/homebrew/etc/bash_completion.d/git-completion.bash"
[[ -r "/opt/homebrew/etc/bash_completion.d/tig-completion.bash" ]] && . "/opt/homebrew/etc/bash_completion.d/tig-completion.bash"
