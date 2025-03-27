#!/usr/bin/env bash

source ./scripts/bash_functions.sh

for file_destination in \
  .bashrc \
  .bash_profile \
  .vimrc \
  .gitconfig \
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
  scripts \
  bin \
; do

  if [[ "$file_destination" =~ ^\.config/ ]]; then
    filename=$(cut -d / -f2- <<< "$file_destination")
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
    if [[ $ec -ne 0 ]]; then
      printf "(ERROR: %d)" $ec
    else
      printf "(done)"
    fi
  fi


  if [[ ! -f ~/$file_destination && ! -d ~/$file_destination ]]; then
    printf "Linking %s\n" $filename
    ln -s $(pwd)/$filename ~/$file_destination 2>/dev/null
  else
    printf "Skipping %s\n" $file_destination
  fi
done
