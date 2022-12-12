#!/usr/bin/python

# Populate maven_modules by recursively parsing the submodules of a provided pom.xml

from sys import argv
from lxml import etree
from sqlite3 import dbapi2

import logging

import argparse

from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--database", required=True)
parser.add_argument("--commit-id", required=True)
parser.add_argument("pom_files", metavar="pom", nargs="+")

args = parser.parse_args()

logging.basicConfig()
logging.getLogger().setLevel(logging.INFO)

log = logging.getLogger("index-pom")

connection = dbapi2.connect(args.database)
cursor = connection.cursor()

namespaces = {"pom": "http://maven.apache.org/POM/4.0.0"}

attempted = set()
candidates = set(args.pom_files)

while p := next(iter(candidates - attempted), None):
    attempted.add(p)

    log.info("Parsing %s", p)
    doc = etree.parse(p).getroot()

    projectList = doc.xpath("/pom:project", namespaces=namespaces)
    if not projectList:
        log.error("Skipping %s due to unexpected root element: %s", p, doc.tag)
        continue

    project = projectList[0]

    groupIdList = project.xpath("pom:groupId/text()", namespaces=namespaces)
    if not groupIdList:
        groupIdList = project.xpath(
            "pom:parent/pom:groupId/text()", namespaces=namespaces
        )
    if not groupIdList:
        log.error("Skipping %s due to lack of groupId", p)
        continue

    groupId = groupIdList[0]

    artifactId = project.xpath("pom:artifactId/text()", namespaces=namespaces)[0]

    cursor.execute(
        "INSERT INTO maven_modules (commit_id, coords, path) VALUES (?, ?, ?)",
        [args.commit_id, groupId + ":" + artifactId, Path(p).parent.as_posix()],
    )

    # Find other modules
    for m in project.xpath(
        "pom:modules/pom:module/text()", namespaces=namespaces
    ) + project.xpath(
        "pom:profiles/pom:profile/pom:modules/pom:module/text()", namespaces=namespaces
    ):
        log.info("In %s found reference to module %s", p, m)
        candidates.add((Path(p).parent / m / "pom.xml").as_posix())


cursor.close()
connection.commit()
connection.close()
