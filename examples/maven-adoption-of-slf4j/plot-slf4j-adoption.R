library(RSQLite)
library(dplyr)

driver <- dbDriver("SQLite")
con <- dbConnect(driver, dbname="record.db")

data <- dbGetQuery(con, "SELECT CAST(strftime('%s', stamp) AS NUMBER) stamp, statistic, MAX(value) AS value FROM commits JOIN commit_stats ON commits.commit_id = commit_stats.commit_id WHERE statistic IN ('slf4j-file-count', 'plexus-logging-file-count', 'maven-plugin-logging-file-count') GROUP BY stamp, statistic")
data$stamp <- as.POSIXct(data$stamp, origin='1970-01-01')

g <- ggplot(data, aes(x=stamp, y=value, fill=statistic)) + geom_area() +
   ylim(0,100) + scale_fill_brewer(palette='Set1')

print(g)
