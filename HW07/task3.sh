#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task3
#SBATCH --output=task3.out
#SBATCH --error=task3.err
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1 --cpus-per-task=4

rm -rf build
mkdir build
cd build
g++ ../task3.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp
./task3