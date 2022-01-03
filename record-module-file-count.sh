#!/bin/sh

set -e

DIR="$(dirname "$0")"

git ls-tree -r --name-only HEAD | grep '\.java$' | sed -n 's,/src/main/.*,,p' | sort | uniq -c | while read num name; do
  "$DIR"/record-module-stat '' "$name" java-file-count "$num"
done
