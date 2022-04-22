#!/bin/bash
#SBATCH --job-name=snow
#SBATCH --nodes=2
#SBATCH --tasks-per-node=128
#SBATCH --time=0:5:0
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --hint=nomultithread

module load cray-R
export R_LIBS_USER=/work/ta065/ta065/$USER/Rinstall
export PATH=$PATH:/work/ta065/ta065/$USER/Rinstall/snow

export OMP_NUM_THREADS=1

srun RMPISNOW < ./simple_parallel_snow.R
