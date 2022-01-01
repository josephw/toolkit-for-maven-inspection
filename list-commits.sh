#!/bin/sh

# List all commit IDs to examine

DB=record.db

sqlite3 "$DB" 'SELECT commit_id FROM commits ORDER BY random();'
