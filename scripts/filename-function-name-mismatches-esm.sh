#!/usr/bin/env sh

# Usage:
#   ./filename-function-name-mismatches.sh [dir_name]

dir=${1:-.}; # Default to "." if no directory argument given

git grep -Po '(?<=export default function) [^(]*' $dir | # Find default exported function names (not matching "export default function")
  sed -E 's#^([a-z]+/)+##i' |         # Remove folders
  sed -E 's/[A-Z]+/-&/g' |            # Prefix groups of uppercase characters with "-"
  sed -E 's/\.js//' |                 # Remove file extension
  tr  '[:upper:]' '[:lower:]' |       # Make all characters lowercase
  awk -F ": " '{                      # Split on ": "
    if ($1 != $2) {                   # Print mismatches
      printf("%s != %s\n", $1, $2);
    }
  }'
