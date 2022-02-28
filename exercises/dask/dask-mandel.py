import sys
import time
from multiprocessing.pool import ThreadPool
import dask
import dask.array as da
import numpy as np
import matplotlib.pyplot as plt

def mandelbrot(h, w, workers, maxit=20, r=2):

    """Returns an image of the Mandelbrot fractal of size (h,w)."""
    start = time.time()

    hsize = 4*h+1
    hchunk = int(hsize/workers)+1
    x = da.linspace(-2.5, 1.5, hsize, chunks=(hchunk))

    wsize = 3*w+1
    wchunk = int(wsize/workers)+1
    y = da.linspace(-1.5, 1.5, wsize, chunks=(wchunk))

    A, B = da.meshgrid(x, y)

    C = A + B*1j

    z = da.zeros_like(C)

    divtime = maxit + da.zeros(z.shape, dtype=int)

    for i in range(maxit):

        z = z**2 + C

        diverge = abs(z) > r                    # who is diverging

        div_now = diverge & (divtime == maxit)  # who is diverging now

        divtime[div_now] = i                    # note when

        z[diverge] = r                          # avoid diverging too much


    z.compute()

    end = time.time()

    return divtime, end-start


h = 200

w = 200

workers = 2

print("Running mandelbrot with ", str(h), "x", str(w), " size and ", str(workers), " workers (threads)")

dask.config.set(pool=ThreadPool(workers))

mandelbrot_space, time = mandelbrot(h, w, workers)

plt.imshow(mandelbrot_space)

print(time)

