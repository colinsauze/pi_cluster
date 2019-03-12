#!/bin/bash

###
#SBATCH --job-name=calculate_pi
#SBATCH --output="Job %J"
#SBATCH --error=err.%J
#SBATCH --ntasks=10
###
cd /home/pi/pi_cluster/mpi_pi_demo
start_time=`date +%s`
mpirun python3 mpi_numpi.py $1
end_time=`date +%s`
echo " Elapsed time $[$end_time-$start_time] seconds"

