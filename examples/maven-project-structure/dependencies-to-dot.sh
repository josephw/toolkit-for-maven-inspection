#!/bin/sh

{ echo 'digraph {'
 sqlite3 record.db 'SELECT DISTINCT PRINTF("""%s"" -> ""%s"";", coords, dependency_coords) FROM maven_dependencies WHERE dependency_coords IN (SELECT coords FROM maven_dependencies);'
 sqlite3 record.db 'SELECT DISTINCT PRINTF("""%s"" [label=<%s<br />%,d lines>]", maven_modules.coords, maven_modules.coords, module_stats.value) FROM maven_modules JOIN module_stats ON maven_modules.commit_id = module_stats.commit_id AND maven_modules.path = module_stats.module WHERE module_stats.statistic="java-source-line-count";'

 echo '}'
} >dependency-graph.dot

dot -Tsvg -O dependency-graph.dot
