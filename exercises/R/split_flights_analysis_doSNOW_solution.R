library(data.table)
library(doSNOW)

flights = fread('flights14.csv')

cl <- getMPIcluster()

workers = as.numeric(Sys.getenv("SLURM_NPROCS"))

registerDoSNOW(cl)

clusterExport(cl,c('flights'))

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

chunk = as.integer(nrow(flights)/workers)
lower = c()
upper = c()
for(i in 1:workers){
 lower[i] = (i-1)*chunk
 upper[i] = i*chunk
}
upper[workers] = nrow(flights)


system.time(results <- foreach (i=1:workers, .combine = '+') %dopar% count.days(lower[i],upper[i])) 

print(results)

stopCluster(cl)
