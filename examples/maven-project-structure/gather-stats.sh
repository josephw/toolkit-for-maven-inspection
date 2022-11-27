#!/bin/sh

set -e

BASE="$(pwd)"
TMI="${BASE}/../.."
SOURCE="$HOME/source/maven"

sqlite3 <"$TMI/create-schema.sql" record.db


cd "$SOURCE"

commit_id="$(git rev-parse HEAD)"
"$TMI"/record-maven-dependencies.sh "$BASE/record.db"
"$TMI"/index-pom.py --database "$BASE/record.db" --commit-id $commit_id pom.xml

sqlite3 "$BASE/record.db" 'SELECT path FROM maven_modules WHERE commit_id="'$commit_id'";' | while read p; do
  "$TMI/record-module-stat" "$commit" "$p" java-source-line-count "$(git ls-files "$p/src/main/java/*/*.java" | xargs cat | wc -l)"
done | sqlite3 "$BASE/record.db"
