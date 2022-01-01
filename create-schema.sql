PRAGMA journal_mode=WAL;

CREATE TABLE commits (commit_id VARCHAR NOT NULL PRIMARY KEY, stamp DATETIME NOT NULL, author_email VARCHAR NOT NULL);

CREATE TABLE commit_stats (commit_id VARCHAR NOT NULL, statistic VARCHAR NOT NULL, value NUMBER NOT NULL);
