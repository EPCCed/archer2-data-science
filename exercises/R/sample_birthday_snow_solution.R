nmax = 50
nworkers <- as.numeric(Sys.getenv("SLURM_NPROCS"))

cl <- getMPIcluster()

pbday <- function(n) {
  ntests <- 100000
  pop <- 1:365
  anydup <- function(i)
  any(duplicated(sample(pop, n,replace=TRUE)))
  sum(sapply(seq(ntests), anydup)) / ntests
}
clusterExport(cl, list('pbday'))

# print the time to do nmax tests, after distributing them to the workers
system.time( x <- clusterApply(cl, 1:nmax, function(n) { pbday(n) }) )

# compute the theoretical probability for each n
prob <- rep(0.0,nmax)
probnot <- 1.0
for (i in 2:nmax) {
  probnot <- probnot*(366.0-i)/365.0
  prob[i] = 1.0 - probnot
}

# print results, comparing tests to theory
z <- cbind(x,prob)
print(z)

# always include the following to stop the cluster
stopCluster(cl)
