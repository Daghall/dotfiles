#!/usr/bin/env bash

for file in .bashrc .bash_profile .vimrc .gitconfig .tigrc; do
  echo -n "Linking $file"
  ln -s $(pwd)/$file ~/$file 2>/dev/null
  if [[ $? -ne 0 ]]; then
    printf " (already exists)"
  fi
  echo ""
done
