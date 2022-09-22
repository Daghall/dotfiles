#!/usr/bin/env sh

printf "Checking pods in "
oc project -q

project=$(basename $(pwd) | sed 's/^bnl-//')

trap exit SIGINT

function normalize_time() {
  read stdin
  echo $stdin \
  | xargs -I _ run-pace -l1 -t _ | cut -d"/" -f1
}

while true; do
  echo "";
  oc get pods | grep $project | while read line; do
    if [[ $line =~ [0-9] ]]; then
      printf "%s – %13s\n" \
        $(echo $line | awk '{ print $1 }') \
        $(echo $line | awk '{ print $NF }' | normalize_time)
    fi
  done | sort -k2
done