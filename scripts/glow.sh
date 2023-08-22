#!/usr/bin/env sh

if [[ $# -eq 1 ]]; then
  glow -s ~/.glow.json $1 | \
    sed -E \
      -e 's_\x1b\[97m([^]*)\x1b\[0m_\1_ig' \
      -e 's/^( *)(-|[0-9]+\.)/\1\x1b[1m\2\x1b[0m/' \
      -e 's/✓/\x1b[32m✓\x1b[0m/' \
      -e 's/✗/\x1b[31m✗\x1b[0m/' \
  ;
else
  glow -s ~/.glow.json
fi
