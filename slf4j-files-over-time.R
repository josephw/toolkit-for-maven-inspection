library(RSQLite)
library(dplyr)
library(lubridate)
library(zoo)

driver = dbDriver("SQLite")
con <- dbConnect(driver,dbname="record.db")

data <- dbGetQuery(con, "SELECT CAST(strftime('%s', stamp) AS NUMBER) stamp, value FROM commits JOIN commit_stats ON commits.commit_id = commit_stats.commit_id WHERE statistic='slf4j-file-count' ORDER BY stamp")
data$stamp <- as.POSIXct(data$stamp, origin='1970-01-01')


g <- data %>% group_by(year=year(stamp)) %>% summarise(files = median(value), min_files = min(value), max_files = max(value)) %>%
 ggplot(., aes(x=year, y=files)) + geom_line() + ylab('Files referencing SLF4J') +
 geom_ribbon(aes(x=year, ymin=min_files, ymax=max_files), alpha=0.25)
print(g)
