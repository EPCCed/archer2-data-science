import time
import sys
from dask.distributed import Client

# We define a function to calculate the area of Pi in a chunk so that we can assign
# it to each worker
# n - the total number of sections of Pi to calculate
# lower - the lowest number of the section of Pi for this chunk.
# upper - the upper limit so that index < upper
def pi_chunk(n, lower, upper):
        step = 1.0 / n
        p = step * sum(4.0/(1.0 + ((i + 0.5) * (i + 0.5) * step * step)) for i in range(lower, upper))
        return p

num_steps = 100000000 # number of slices

# Default to 4 worker
workers = 4

print("Calculating PI using:\n  " + str(num_steps) + " slices")
print("  " + str(workers) + " workers")

start = time.time()

#client = Client(processes=False, n_workers=workers)  # start local workers as threads

stop = time.time()

print("Dask setup time ",stop - start,"seconds")

start = time.time()

num_steps_range = [num_steps] * workers
lower_range =  [int(a * (num_steps/workers)) for a in range(workers)]
upper_range =  [int((a + 1) * (num_steps/workers)) for a in range(workers)]
upper_range[workers-1] =  num_steps

futures = client.map(pi_chunk, num_steps_range, lower_range, upper_range)

results = client.gather(futures)
pi = sum(results)
stop = time.time()

print("pi: ", pi)
print("The calculation took", stop - start,"seconds")
