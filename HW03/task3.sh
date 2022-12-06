#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=hw3task3
#SBATCH --output=hw3task3.out
#SBATCH --error=hw3task3.err
#SBATCH --time=0-00:05:00
#SBATCH --gres=gpu:1

# module load nvidia/cuda

rm -rf build
mkdir build
cd build
nvcc ../task3.cu ../vscale.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task3

for i in {10..29}
do
    echo "Now n = $[2**$i]"
    ./task3 $[2**$i]
done