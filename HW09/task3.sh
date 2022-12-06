#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task3
#SBATCH --output=task3.out
#SBATCH --error=task3.err
#SBATCH --time=0-00:10:00
#SBATCH --ntasks-per-node=2

# module load mpi/mpich/4.0.2

rm -rf build
mkdir build
cd build
mpicxx ../task3.cpp -Wall -O3 -o task3

# srun -n 2 task3 512

for i in {1..25}
do
    echo "Now n = $[2**$i]"
    srun -n  2 ./task3 $[2**$i]
done