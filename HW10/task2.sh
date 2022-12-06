#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task2
#SBATCH --output=task2.out
#SBATCH --error=task2.err
#SBATCH --time=0-00:10:00
#SBATCH --nodes=2 --cpus-per-task=20 --ntasks-per-node=1

# module load mpi/mpich/4.0.2

rm -rf build
mkdir build
cd build
mpicxx ../task2.cpp ../reduce.cpp -Wall -O3 -o task2 -fopenmp -fno-tree-vectorize -march=native -fopt-info-vec

srun -n 2 --cpu-bind=none ./task2 1000000000 10

# for t in {1..20}
# do
#     srun -n 2 --cpu-bind=none ./task2 10000000 $t
# done

# for i in {1..26}
# do
#     echo -e "\nNow n = $[2**$i]"
#     srun -n 2 --cpu-bind=none ./task2 $[2**$i] 10
# done