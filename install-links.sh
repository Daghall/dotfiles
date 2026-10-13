#!/usr/bin/env bash

source ./scripts/bash_functions.sh

function check_success() {
  if [[ $1 -ne 0 ]]; then
    printf "(ERROR: %d)\n" $ec
  else
    printf "(done)\n"
  fi
}

for file_destination in \
  .bashrc \
  .bash_profile \
  .vimrc \
  .gitconfig \
  .gitconfig-bn \
  .git-hooks/pre-push \
  .tigrc \
  .inputrc \
  .glow.json \
  .vim/bundle/vimspector/configurations/macos/_all/vimspector.json \
  .vim/colors/daghall.vim \
  .config/ranger/rc.conf \
  .config/gh/config.yml \
  .config/gh/hosts.yml \
  .config/karabiner/karabiner.json \
  .config/bat/themes/daghall.tmTheme \
  .config/btop/btop.conf \
  .config/bettercmdtab/config.json \
  scripts \
  bin \
; do

  if [[ "$file_destination" =~ / ]]; then
    filename=${file_destination/.config\//}
    dir="$HOME/$(dirname $file_destination)"
  else
    filename=$(basename $file_destination | sed 's#__#/#g')
    dir="."
  fi

  DEBUG_LOG "  $filename → ~/$file_destination"
  DEBUG_LOG "  directory: $dir"

  if [[ ! -d "$dir" ]]; then
    printf "Creating directory %s " $dir
    mkdir -p "$dir"

    ec=$?
    check_success $ec
  fi


  if [[ ! -L "$HOME/$file_destination" ]]; then
    printf "Linking %s " $filename
    ln -s $(pwd)/$filename ~/$file_destination 2>/dev/null

    ec=$?
    check_success $ec
  else
    printf "Skipping %s\n" $file_destination
  fi
done

# SSH config handling
if [[ ! -d ~/.ssh ]]; then
  echo "Creating SSH directory"
  mkdir ~/.ssh
  chmod 700 ~/.ssh
fi

if [[ ! -f ~/.ssh/config ]]; then
  echo "Creating SSH config file"
  touch ~/.ssh/config
  chmod 644 ~/.ssh/config
fi

INCLUDE_LINE="Include $(pwd)/.ssh/config"
if ! grep -Fxq "$INCLUDE_LINE" ~/.ssh/config; then
  echo "Adding SSH config include line"
  # Use vim to add the line to the end of the file, to make it POSIX compliant,
  # since it may lack a trailing newline. I'm looking at you, Colima...
  vim +":normal Go$INCLUDE_LINE" ~/.ssh/config +wq
else
  echo "Skipping SSH config"
fi
