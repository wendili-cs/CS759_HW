#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task2
#SBATCH --output=task2.out
#SBATCH --error=task2.err
#SBATCH --time=0-00:10:00
#SBATCH --gres=gpu:1

# module load nvidia/cuda

rm -rf build
mkdir build
cd build
nvcc ../task2.cu ../stencil.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o task2

# ./task2 10 1 3

for i in {10..29}
do
    echo "Now n = $[2**$i]"
    ./task2 $[2**$i] 128 1024
done