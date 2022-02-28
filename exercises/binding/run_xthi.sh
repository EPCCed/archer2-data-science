#!/bin/bash
#SBATCH --job-name=xthi
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=0:5:0
#SBATCH --partition=standard
#SBATCH --qos=short

export OMP_NUM_THREADS=1

module load xthi 
srun --distribution=block:block xthi
