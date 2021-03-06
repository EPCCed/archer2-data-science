#!/bin/bash
#SBATCH --job-name=snow
#SBATCH --nodes=2
#SBATCH --tasks-per-node=128
#SBATCH --time=0:5:0
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --hint=nomultithread

module load cray-R
export R_LIBS_USER=/work/ta065/$USER/Rinstall
export PATH=$PATH:/work/ta065/ta065/$USER/Rinstall/snow

export OMP_NUM_THREADS=1

R --no-save <<EOF
library(snowfall)
workers = as.numeric(Sys.getenv("SLURM_NPROCS"))
sfInit(parallel=TRUE,cpus=workers)
x <- sfLapply(1:workers, function(x) system("hostname",intern=TRUE))
print(unlist(x))
sfStop()
EOF
