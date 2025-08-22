#!/usr/bin/env bash

plugins=$(ls -1 ~/.vim/bundle/)
date=$(date +%Y-%m-%d)

for plugin in $plugins; do
  printf "Updating \x1b[33m%s\x1b[0m\n" "$plugin"
  cd ~/.vim/bundle/$plugin

  branch=$(git rev-parse --abbrev-ref HEAD)
  git checkout -b "backup-$date"
  exit=$?

  if [[ $exit -eq 0 ]]; then
    git checkout $branch
    git fetch
    git log --oneline --left-right ..origin/$branch
    git pull --ff
    exit=$?
  fi

  if [ $exit -ne 0 ]; then
    printf "\x1b[31mUpdate failed\x1b[0m\n"
  else
    printf "\x1b[32mUpdate succesful\x1b[0m\n"
  fi

  echo ""
done
