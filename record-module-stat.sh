#!/bin/sh

DB=record.db

commit="$(git rev-parse HEAD)"
module="${1:?Specify module path}"
stat_name="${2:?Specify statistic name}"
value="${3:?Specify value}"

echo "$commit / $module / $stat_name=$value"

# XXX Not safely encoded
sqlite3 "$DB" "INSERT INTO module_stats (commit_id, module, statistic, value) VALUES (\"$commit\", \"$module\", \"$stat_name\", $value);"
