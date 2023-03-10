#!/usr/bin/env sh

if [[ $# -ne 1 ]]; then
  printf "Usage:\n  %s <file>\n" $(echo $0 | sed -e "s#${HOME}#~#");
  exit 1;
fi

file=$1

functions=$(
  egrep -oi "^  [a-z_]+\(" \
    $file | \
    awk '{ gsub("[(]", ""); print $1 }'
);

printf "\e[33mChecking \e[1;33m$file\e[0m\n";
for function in $functions; do
  matches=$(git grep $function | wc -l);

  if [[ $matches -eq 1 ]]; then
    printf "Potentially unused: \e[32m$function\e[0m\n";
  fi;
done
