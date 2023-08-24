#!/usr/bin/env sh

# Use first argument as image name, or take from clipboard
case $# in
  1 )
    image=$1
    ;;
  0 )
    image=$(pbpaste)
    ;;
esac

if [[ -z $image ]]; then
  echo "Malformed/missing image name" >&2
  exit 1
fi

docker pull "$image" && \
docker -it --entrypoint sh "$image"
