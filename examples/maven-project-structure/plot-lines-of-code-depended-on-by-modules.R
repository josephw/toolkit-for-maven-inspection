library(RSQLite)

# Plot the total lines of code depended on by each module

driver <- dbDriver("SQLite")
con <- dbConnect(driver, dbname="record.db")

dbExecute(con, r"(CREATE TEMP VIEW internal_maven_dependencies AS SELECT * FROM maven_dependencies WHERE dependency_coords IN (SELECT coords FROM maven_dependencies);)")
dbExecute(con, r"(CREATE TEMP VIEW maven_modules_with_stats AS SELECT maven_modules.commit_id, coords, module_stats.value FROM maven_modules JOIN module_stats ON maven_modules.commit_id = module_stats.commit_id AND maven_modules.path = module_stats.module;)")

data <- dbGetQuery(con, "SELECT internal_maven_dependencies.coords, SUM(value) AS lines FROM internal_maven_dependencies JOIN maven_modules_with_stats ON dependency_coords = maven_modules_with_stats.coords GROUP BY internal_maven_dependencies.coords");

g <- ggplot(data, aes(x=1:length(lines), y=sort(lines))) + geom_point() +
         xlab('Rank') + ylab('LoC depended on') +
         scale_y_continuous(labels = label_comma())

print(g)
