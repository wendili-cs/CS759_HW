#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task1
#SBATCH --output=task1.out
#SBATCH --error=task1.err
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1 --cpus-per-task=1

rm -rf build
mkdir build
cd build
g++ ../task1.cpp ../optimize.cpp -Wall -O3 -std=c++17 -o task1 -fno-tree-vectorize

# g++ ../task1.cpp ../optimize.cpp -Wall -O3 -std=c++17 -o task1 -march=native -fopt-info-vec -ffast-math

./task1 1000000