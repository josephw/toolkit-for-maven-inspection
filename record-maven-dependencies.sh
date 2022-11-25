#!/bin/sh

set -e

db="${1:?Specify database path}"

DIR="$(dirname "$0")"

mvn dependency:tree -DoutputFile=`pwd`/mvn_dependency_tree.txt -DappendOutput=true -o -DoutputType=text

"${DIR}/parse-dependencies.py" "$db" <mvn_dependency_tree.txt "$(git rev-parse HEAD)"
