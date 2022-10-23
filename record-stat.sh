#!/bin/sh

commit="${1:?Specify commit}"
stat_name="${2:?Specify statistic name}"
value="${3:?Specify value}"

echo >&2 "$commit / $stat_name=$value"

# XXX Not safely encoded
echo "INSERT INTO commit_stats (commit_id, statistic, value) VALUES (\"$commit\", \"$stat_name\", $value);"
