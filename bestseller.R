install.packages("jsonlite")
library(jsonlite)
library(dplyr)

#Input your own API key here
NYTIMES_KEY="XXX"

list <- fromJSON(paste0("https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=", NYTIMES_KEY, sep = ''))
list$results$list_name
#select the format (list_name) you are interested in

#Edit the start and end date accordingly
start_date <- as.Date("2023-04-16",format="%Y-%m-%d")
end_date <- as.Date("2023-01-01",format="%Y-%m-%d")

#Loop API calls across those dates on a weekly basis
df <- data.frame()
while (start_date >= end_date){
  x <- fromJSON(paste0("https://api.nytimes.com/svc/books/v3/lists/", start_date, "/paperback-nonfiction.json?&api-key=", NYTIMES_KEY, sep = ''))
  books <- data.frame(x$results$books)
  books <- books %>% select(title, author, rank ,weeks_on_list)
  data <- cbind(books, data.frame(x$results$published_date))
  df <- rbind(df, data)
  start_date <- start_date - 7        
  Sys.sleep(10)
}
