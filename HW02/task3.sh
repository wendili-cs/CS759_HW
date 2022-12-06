#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=hw2task3
#SBATCH --output=hw2task3.out
#SBATCH --error=hw2task3.err
#SBATCH --time=0-00:05:00
#SBATCH -c 4

rm -rf build
mkdir build
cd build
g++ ../matmul.cpp ../task3.cpp -Wall -O3 -std=c++17 -o task3
./task3