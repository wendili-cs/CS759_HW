#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=hw3task1
#SBATCH --output=hw3task1.out
#SBATCH --error=hw3task1.err
#SBATCH --time=0-00:05:00
#SBATCH --gres=gpu:1

# module load nvidia/cuda

rm -rf build
mkdir build
cd build
nvcc ../task1.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task1
./task1