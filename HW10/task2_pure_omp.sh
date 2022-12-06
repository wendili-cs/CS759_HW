#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task2_pure_omp
#SBATCH --output=task2_pure_omp.out
#SBATCH --error=task2_pure_omp.err
#SBATCH --time=0-00:10:00
#SBATCH --nodes=2 --cpus-per-task=20 --ntasks-per-node=1

rm -rf build
mkdir build
cd build

g++ ../task2_pure_omp.cpp ../reduce.cpp -Wall -O3 -o task2_pure_omp -fopenmp -fno-tree-vectorize -march=native -fopt-info-vec

./task2_pure_omp 200000000 10

# for t in {1..20}
# do
#     ./task2_pure_omp 20000000 $t
# done

# for i in {2..27}
# do
#     echo -e "\nNow n = $[2**$i]"
#     ./task2_pure_omp $[2**$i] 10
# done