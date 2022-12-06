#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task1
#SBATCH --output=task1.out
#SBATCH --error=task1.err
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1 --cpus-per-task=10

rm -rf build
mkdir build
cd build
g++ ../task1.cpp ../cluster.cpp -Wall -O3 -std=c++17 -o task1 -fopenmp

# ./task1 8 2

for i in {1..10}
do
    echo "Now t = $i:"
    ./task1 5040000 $i
done