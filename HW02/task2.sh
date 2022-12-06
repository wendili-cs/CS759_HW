#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=hw2task2
#SBATCH --output=hw2task2.out
#SBATCH --error=hw2task2.err
#SBATCH --time=0-00:05:00
#SBATCH -c 4

rm -rf build
mkdir build
cd build
g++ ../convolution.cpp ../task2.cpp -Wall -O3 -std=c++17 -o task2
./task2 100 3