#!/usr/bin/env bash

source ~/scripts/bash_functions.sh

if [[ $# -ne 1 ]]; then
  echo "Usage: git-undo.sh <hash>"
  exit 1
fi

hash=$1

DEBUG_LOG "Hash: $hash"

git show --no-patch $hash

printf "\n\x1b[32mUndoing this commit? [y/N] \x1b[0m"

read -r answer

DEBUG_LOG "Answer: $answer"

if [[ ! $answer =~ ^[Yy]$ ]]; then
  echo "Aborting..."
  exit 1
fi

diff=$(git diff $hash^ $hash)

DEBUG_LOG "Diff: $diff"

git apply -R <<< "$diff"

ec=$?

DEBUG_LOG "Exit code: $ec"

if [[ $ec -ne 0 ]]; then
  printf "\n\x1b[31mFailed to apply diff\x1b[0m\n\n"
  exit 1
else
  printf "\n\x1b[32mUndid changes from commit %.8s\n\n\x1b[0m" $hash
fi
