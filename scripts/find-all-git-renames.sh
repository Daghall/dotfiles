#!/usr/bin/env bash

# Takes a file path as its only argument,
# and prints the current file path of
# that file, by stepping through its git history,
# in reverse

source ~/scripts/bash_functions.sh

filename=$1
new_filename=$1

while [[ $new_filename != "" ]]; do
  last_commit=$(git log --format="%h" --follow -- $new_filename | head -1)
  DEBUG_LOG "Last commit: $last_commit"

  new_filename=$(git show $last_commit | grep -A1 "rename from $filename" | tail -1 | awk '{ print $NF }')
  if [[ $new_filename != "" ]]; then
    DEBUG_LOG "Renamed $filename => $new_filename"
    filename=$new_filename
  fi
done

echo $filename
