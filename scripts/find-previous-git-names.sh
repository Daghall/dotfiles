#!/usr/bin/env bash

filename=$1

git log --numstat --follow -- $filename | \
  grep '=>' | \
  awk -F\t '{
    split($3, res, "( => |[{}])");
    printf("%s%s%s\n%s%s%s\n", res[1], res[3], res[4], res[1], res[2], res[4])
  }' | \
  uniq
