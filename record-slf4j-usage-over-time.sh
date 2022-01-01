#!/bin/sh

set -e

DIR="$(dirname "$0")"

"$DIR/list-commits.sh" | while read commit; do
  "$DIR/record-stat" "$commit" slf4j-file-count "$(git grep -l 'org.slf4j' $commit -- \*.java | wc -l)"
done

