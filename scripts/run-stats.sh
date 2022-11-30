#!/usr/bin/env bash

stats() {
  total_runs=$(($successful_runs + $failed_runs))
  success_rate=$(node -p "100 * ($successful_runs / $total_runs)")
  fail_rate=$(node -p "100 * ($failed_runs / $total_runs)")

  printf "– – – – – – –\n"
  printf "Succesful %3d (%5.1f %%)\n" $successful_runs $success_rate
  printf "Failed    %3d (%5.1f %%)\n" $failed_runs $fail_rate
  printf "Total     %3d\n" $total_runs
}

killed() {
  stats
  exit 0
}

trap killed SIGINT

exit_code=0
successful_runs=0
failed_runs=0

while true; do
  $@

  if [[ $? -eq 0 ]]; then
    successful_runs=$(($successful_runs + 1))
  else
    failed_runs=$(($failed_runs + 1))
  fi

  stats
done
