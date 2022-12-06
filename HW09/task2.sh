#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task2
#SBATCH --output=task2.out
#SBATCH --error=task2.err
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1 --cpus-per-task=10

rm -rf build
mkdir build
cd build
g++ ../task2.cpp ../montecarlo.cpp -Wall -O3 -std=c++17 -o task2 -fopenmp -fno-tree-vectorize -march=native -fopt-info-vec

for i in {1..10}
do
    echo "Now t = $i:"
    ./task2 1000000 $i
done