#!/bin/sh

set -e

DIR="$(dirname "$0")"

mvn dependency:tree -DoutputFile=`pwd`/mvn_dependency_tree.txt -DappendOutput=true -o -DoutputType=text

"${DIR}/parse-dependencies.py" <mvn_dependency_tree.txt "$(git rev-parse HEAD)"
