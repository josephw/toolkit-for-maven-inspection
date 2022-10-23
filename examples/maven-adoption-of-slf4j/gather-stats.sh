#!/bin/sh

set -e

BASE="$(pwd)"
TMI="${BASE}/../.."
SOURCE="$HOME/source/maven"

sqlite3 <"$TMI/create-schema.sql" record.db


cd "$SOURCE"

"$TMI"/record-commits.sh "$BASE/record.db"

{
sqlite3 "${BASE}/record.db" 'SELECT commit_id FROM commits ORDER BY stamp DESC LIMIT 500; SELECT commit_id FROM commits ORDER BY random() LIMIT 5000;'
} | sort -u |
# "$TMI/list-commits.sh" | head -n 5000 |
while read commit; do
  "$TMI/record-stat" "$commit" slf4j-file-count "$(git grep -l 'org.slf4j.Logger' $commit -- \*.java | wc -l)"
  "$TMI/record-stat" "$commit" plexus-logging-file-count "$(git grep -l 'org.codehaus.plexus.logging.Logger' $commit -- \*.java | wc -l)"
  "$TMI/record-stat" "$commit" maven-plugin-logging-file-count "$(git grep -l 'org.apache.maven.plugin.logging.Log' $commit -- \*.java | wc -l)"
done | sqlite3 "$BASE/record.db"
