nmax = 50

pbday <- function(n) {
  ntests <- 100000
  pop <- 1:365
  anydup <- function(i)
  any(duplicated(sample(pop, n,replace=TRUE)))
  sum(sapply(seq(ntests), anydup)) / ntests
}


x <- rep(0.0,nmax)
# print the time to do nmax tests, after distributing them to the workers
system.time(apply(x, 1:nmax, function(n) { pbday(n) }) )

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


