#!/usr/bin/env bash

for file_destination in \
  .bashrc \
  .bash_profile \
  .vimrc \
  .gitconfig \
  .tigrc \
  .inputrc \
  .vim/bundle/vimspector/configurations/macos/_all/vimspector.json \
; do
  filename=$(basename $file_destination)
  echo -n "Linking $filename"
  ln -s $(pwd)/$filename ~/$file_destination 2>/dev/null

  if [[ $? -ne 0 ]]; then
    if [[ -f ~/$file_destination ]]; then
      printf " (already exists)"
    else
      printf " (ERROR)"
    fi
  fi
  echo ""
done
