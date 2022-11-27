#!/bin/sh

DB=record.db

commit="${1:-$(git rev-parse HEAD)}"
module="${2:?Specify module path}"
stat_name="${3:?Specify statistic name}"
value="${4:?Specify value}"

echo >&2 "$commit / $module / $stat_name=$value"

# XXX Not safely encoded
echo "INSERT INTO module_stats (commit_id, module, statistic, value) VALUES (\"$commit\", \"$module\", \"$stat_name\", $value);"
