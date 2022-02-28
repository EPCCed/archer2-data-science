from dask_jobqueue import SLURMCluster
cluster = SLURMCluster(cores=128, 
                       processes=128,
                       memory='256GB',
                       queue='standard',
                       header_skip=['--mem'],
                       job_extra=['--qos="short"'],
                       python='srun python',
                       project='XXXX',
                       walltime="00:10:00",
                       shebang="#!/bin/bash --login",
                       local_directory='$PWD',
                       env_extra=['module load cray-python',
                                  'export PYTHONUSERBASE=/work/XXX/XXX/XXXXXXX/.local/',
                                  'export PATH=$PYTHONUSERBASE/bin:$PATH',
                                  'export PYTHONPATH=$PYTHONUSERBASE/lib/python3.8/site-packages:$PYTHONPATH'])


cluster.scale(jobs=2)    # Deploy two single-node jobs

from dask.distributed import Client
client = Client(cluster)  # Connect this local process to remote workers

from dask.distributed import get_client

print(client.scheduler_info())
print(client)

import dask.array as da
x = da.random.random((10000, 10000), chunks=(1000, 1000))
mean = x.mean().compute()
print(mean)
print(client)
