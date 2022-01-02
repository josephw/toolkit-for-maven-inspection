library(RSQLite)

driver = dbDriver("SQLite")
con <- dbConnect(driver,dbname="record.db")

data <- dbGetQuery(con, "SELECT module, value FROM module_stats WHERE statistic='java-file-count'")

g <- ggplot(data, aes(x=value)) + geom_histogram() + xlab('Number of source files')
print(g)
