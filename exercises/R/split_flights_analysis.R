library(data.table)

flights = fread('flights14.csv')

# Convert the day and month into a number representing the position in the year
# Note, this is a badly implemented way of doing this, only suitable for demonstrating functionality
# and should never be used anywhere else.
get.day <- function(day, month) {
  months = c(31,28,31,30,31,30,31,31,30,31,30,31)
  total_days = 0
  if(month > 1){
    for (i in 1:(month-1)) {
       total_days = total_days + months[i]
    } 
  }
  total_days + day
}

# Count the number of flights on each day, using get.day to convert day/month format into a single day
# number. Work on the flights data.table using the provided upper and lower range of rows to process.
count.days <- function(lower, upper) {
  counts <- rep(0,365)
  days <-  unlist(mapply(get.day, flights$day[lower:upper], flights$month[lower:upper]))
  hist <- rle( sort(days) )
  for (i in 1:length(hist$values)) {
    j <- hist$values[i] + 1
    counts[j] <- hist$lengths[i]
  }
 counts
}

system.time(results <- count.days(1,nrow(flights)))

results
