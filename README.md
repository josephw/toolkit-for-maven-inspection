## Toolkit for Maven Inspection

Lashed-together command-line scripts for getting information out of Maven projects.

### Why?

In trying to make sense of large Maven projects, structurally and over time, I've
written the same one-liners several times. However, that same ad-hoc approach
makes it difficult to combine results and look for correlations. Now, those same
lashed-together command-line scripts are coupled with some database tables, to
make it easier to capture once, then query.

### Usage

1. In a project directory, run `sqlite3 create-schema.sql`
2. Invoke some of the scripts to capture data about the project
3. Extract data and plot it
