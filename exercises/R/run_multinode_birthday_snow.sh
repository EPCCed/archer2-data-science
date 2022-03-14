#!/bin/bash
#SBATCH --job-name=snow
#SBATCH --nodes=1
#SBATCH --tasks-per-node=64
#SBATCH --time=0:5:0
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --account=z19
#SBATCH --hint=nomultithread

module load cray-R
export R_LIBS_USER=/work/z19/z19/adrianj/Rinstall
export PATH=$PATH:/work/z19/z19/adrianj/Rinstall/snow

export OMP_NUM_THREADS=1

srun RMPISNOW < ./sample_birthday_snow.R
