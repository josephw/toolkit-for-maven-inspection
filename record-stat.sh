#!/bin/sh

DB=record.db

commit="${1:?Specify commit}"
stat_name="${2:?Specify statistic name}"
value="${3:?Specify value}"

echo "$commit / $stat_name=$value"

# XXX Not safely encoded
sqlite3 "$DB" "INSERT INTO commit_stats (commit_id, statistic, value) VALUES (\"$commit\", \"$stat_name\", $value);"
