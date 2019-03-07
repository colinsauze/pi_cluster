#!/bin/bash

###
#SBATCH --job-name=calculate_pi
#SBATCH --output=out.%J
#SBATCH --error=err.%J
#SBATCH --ntasks=10
###
mpirun python3 mpi_numpi.py $1
