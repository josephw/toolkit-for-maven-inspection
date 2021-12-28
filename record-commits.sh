#!/bin/sh

# Get a record of all commits, with dates

DB=record.db

# commit_id,stamp,author_email
git log --format='%H,%aI,%aE' --first-parent |
 sqlite3 "$DB" ".import --csv /dev/stdin commits"
