#!/bin/sh

set -e

BASE="$(pwd)"
TMI="${BASE}/../.."
SOURCE="$HOME/source/maven"

sqlite3 <"$TMI/create-schema.sql" record.db


cd "$SOURCE"

"$TMI"/record-maven-dependencies.sh "$BASE/record.db"
