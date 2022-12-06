#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task1
#SBATCH --output=task1.out
#SBATCH --error=task1.err
#SBATCH --time=0-00:10:00
#SBATCH --gres=gpu:1

# module load nvidia/cuda

rm -rf build
mkdir build
cd build
nvcc ../task1.cu ../matmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o task1

for i in {5..14}
do
    echo "Now n = $[2**$i]"
    ./task1 $[2**$i] 1024
done