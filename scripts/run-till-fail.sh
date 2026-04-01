#!/usr/bin/env bash

stats() {
  printf "Succesful runs: %d\n" $successful_runs;
}

trap stats SIGINT

exit_code=0
successful_runs=0

while [[ $exit_code -eq 0 ]]; do
  "$@"
  exit_code=$?

  if [[ $exit_code -eq 0 ]]; then
    successful_runs=$(($successful_runs + 1))
  fi

  stats
done
