#!/usr/bin/python3

# Parse the output of:
#   mvn dependency:tree -DoutputFile=`pwd`/mvn_dependency_tree.txt -DappendOutput=true -o -DoutputType=text
# and store it in the database

from sys import argv, exit, stdin, stderr
import re
from sqlite3 import dbapi2

if len(argv) != 2:
  print(f'Usage: {argv[0]} <commit ID>', file=stderr)
  exit(5)

commit_id = argv[1]

connection = dbapi2.connect("record.db")
cursor = connection.cursor()

dl = re.compile(r'^[| ]*(?:\+|\\)- (.*)$')

coords = re.compile(r'^([^:]+:[^:]+)(?::.*)$')
coords_and_scope = re.compile(r'^([^:]+:[^:]+)(?::.*):(\w+)( \(optional\))?$')

def insert_into_db(coords, dependency, scope):
  cursor.execute('INSERT INTO maven_dependencies (commit_id, coords, dependency_coords, dependency_scope) VALUES (?, ?, ?, ?)', [commit_id, coords, dependency, scope])

current_coords = None

for l in stdin:
  l = l.rstrip()
  m = dl.match(l)
  if m:
    cs = coords_and_scope.match(m.group(1))
    if cs:
      insert_into_db(current_coords, cs.group(1), cs.group(2))
    else:
      print(f' (unable to parse {m.group(1)}', file=stderr)
      exit(5)
  else:
    current_coords = coords.match(l).group(1)

cursor.close()
connection.commit()
connection.close()
