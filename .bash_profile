# Source bashrc
. ~/.bashrc

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/markus.daghall/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/markus.daghall/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/markus.daghall/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/markus.daghall/Downloads/google-cloud-sdk/completion.bash.inc'; fi

complete -C /usr/local/bin/terraform terraform
