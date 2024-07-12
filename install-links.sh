#!/usr/bin/env bash

source ./scripts/bash_functions.sh

for file_destination in \
  .bashrc \
  .bash_profile \
  .vimrc \
  .gitconfig \
  .tigrc \
  .inputrc \
  .vim/bundle/vimspector/configurations/macos/_all/vimspector.json \
  .config/ranger/rc.conf \
  .config/gh/config.yml \
  .config/gh/hosts.yml \
  .config/karabiner/karabiner.json \
; do

  if [[ "$file_destination" =~ ^\.config/ ]]; then
    filename=$(cut -d / -f2- <<< "$file_destination")
  else
    filename=$(basename $file_destination | sed 's#__#/#g')
  fi

  DEBUG_LOG "  $filename → ~/$file_destination"

  printf "Linking %s" $filename
  ln -s $(pwd)/$filename ~/$file_destination 2>/dev/null

  if [[ $? -ne 0 ]]; then
    if [[ -f ~/$file_destination ]]; then
      printf " (already exists)"
    else
      printf " (ERROR)"
    fi
  fi
  printf "\n"
done
