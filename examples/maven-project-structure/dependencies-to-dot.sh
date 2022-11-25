#!/bin/sh

{ echo 'digraph {'; sqlite3 record.db 'SELECT DISTINCT FORMAT("""%s"" -> ""%s"";", coords, dependency_coords) FROM maven_dependencies WHERE dependency_coords IN (SELECT coords FROM maven_dependencies);'; echo '}'; } >dependency-graph.dot

dot -Tsvg -O some-file.dot
