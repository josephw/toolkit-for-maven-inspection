#!/bin/sh

# Get a record of all commits, with dates

DB=record.db

{
echo commit_id,stamp
git log --format='%H,%aI' --first-parent
} |
 sqlite3 "$DB" ".import --csv /dev/stdin commits"
