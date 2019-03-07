#!/bin/bash

###
#SBATCH --job-name=calculate pi
#SBATCH --output=mpi_pi.out.%J.%N
#SBATCH --error=mpi_pi.err.%J.%N
#SBATCH --ntasks=2
###
mpirun python3 mpi_numpi.py 10000000
