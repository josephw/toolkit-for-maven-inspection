PRAGMA journal_mode=WAL;

CREATE TABLE commits (
  commit_id VARCHAR NOT NULL PRIMARY KEY,
  stamp DATETIME NOT NULL,
  author_email VARCHAR NOT NULL
);

CREATE TABLE commit_stats (
  commit_id VARCHAR NOT NULL,
  statistic VARCHAR NOT NULL,
  value NUMBER NOT NULL,
  PRIMARY KEY (commit_id, statistic)
);

CREATE TABLE module_stats (
  commit_id VARCHAR NOT NULL,
  module VARCHAR NOT NULL,
  statistic VARCHAR NOT NULL,
  value NUMBER NOT NULL,
  PRIMARY KEY (commit_id, module, statistic)
);

CREATE TABLE maven_dependencies (
  commit_id VARCHAR NOT NULL,
  coords VARCHAR NOT NULL,
  dependency_coords VARCHAR NOT NULL,
  dependency_version VARCHAR,
  dependency_scope VARCHAR
);

CREATE TABLE maven_modules (
  commit_id VARCHAR NOT NULL,
  coords VARCHAR NOT NULL,
  path VARCHAR NOT NULL,
  PRIMARY KEY (commit_id, coords),
  UNIQUE (commit_id, path)
);
