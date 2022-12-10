library(RSQLite)

# Plot the total lines of code depended on by each module

driver <- dbDriver("SQLite")
con <- dbConnect(driver, dbname="record.db")

dbExecute(con, r"(CREATE TEMP VIEW internal_maven_dependencies AS SELECT * FROM maven_dependencies WHERE dependency_coords IN (SELECT coords FROM maven_dependencies);)")
dbExecute(con, r"(CREATE TEMP VIEW maven_modules_with_stats AS SELECT maven_modules.commit_id, coords, module_stats.value FROM maven_modules JOIN module_stats ON maven_modules.commit_id = module_stats.commit_id AND maven_modules.path = module_stats.module;)")

data_deps <- dbGetQuery(con, "SELECT internal_maven_dependencies.coords, SUM(value) AS dependency_lines FROM internal_maven_dependencies JOIN maven_modules_with_stats ON dependency_coords = maven_modules_with_stats.coords GROUP BY internal_maven_dependencies.coords");
data_self <- dbGetQuery(con, "SELECT coords, value AS self_lines FROM maven_modules_with_stats");

data <- inner_join(data_deps, data_self, by="coords") %>% arrange(dependency_lines) %>% mutate(lines = dependency_lines + self_lines)

lines_maven_api_core <- data$lines[data$coords=='org.apache.maven:maven-api-core']
lines_maven_core <- data$lines[data$coords=='org.apache.maven:maven-core']
lines_apache_maven <- data$lines[data$coords=='org.apache.maven:apache-maven']

g <- ggplot(data, aes(x=1:length(dependency_lines), y=lines, ymin=dependency_lines, ymax=lines)) +
         geom_pointrange(color='darkgreen') + geom_point() +
         xlab('Rank') + ylab('LoC including dependencies') +
         scale_y_continuous(labels = label_comma()) +
         geom_hline(yintercept=lines_maven_api_core, linetype='dotted', alpha=0.8) + geom_text(aes(0, lines_maven_api_core, label = 'maven-api-core'), vjust=-1) +
         geom_hline(yintercept=lines_maven_core, linetype='dotted', alpha=0.8) + geom_text(aes(0, lines_maven_core, label = 'maven-core'), vjust=-1) +
         geom_hline(yintercept=lines_apache_maven, linetype='dotted', alpha=0.8) + geom_text(aes(0, lines_apache_maven, label = 'apache-maven'), vjust=-1)

print(g)
