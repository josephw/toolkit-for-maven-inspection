library(RSQLite)
library(dplyr)

driver = dbDriver("SQLite")
con <- dbConnect(driver,dbname="record.db")

data <- dbGetQuery(con, "SELECT CAST(strftime('%s', stamp) AS NUMBER) stamp, author_email FROM commits")
data$stamp <- as.POSIXct(data$stamp, origin='1970-01-01')

g <- data %>% group_by(year=strftime(stamp, '%Y')) %>% summarise(n=n_distinct(author_email)) %>% ggplot(., aes(x=year, y=n)) + geom_bar(stat='identity') + ylab('Committer count')
print(g)
