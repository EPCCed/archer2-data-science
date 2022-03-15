#!/bin/bash
#SBATCH --job-name=snow
#SBATCH --nodes=2
#SBATCH --tasks-per-node=128
#SBATCH --time=0:5:0
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --hint=nomultithread

module load cray-R
# The paths below may need changed if you have installed your R packages (particularly Snow) elsewhere
# Remember, we need the R packages installed on /work to be able to use them on the compute nodes on ARCHER2
export R_LIBS_USER=/work/ta055/ta055/$USER/Rinstall
export PATH=$PATH:/work/ta055/ta055/$USER/Rinstall/snow

export OMP_NUM_THREADS=1

srun RMPISNOW < ./sample_birthday_snow.R
