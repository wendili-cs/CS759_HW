#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task1
#SBATCH --output=task1.out
#SBATCH --error=task1.err
#SBATCH --time=0-00:30:00
#SBATCH --gres=gpu:1

# module load nvidia/cuda

rm -rf build
mkdir build
cd build
nvcc ../task1.cu ../mmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -lcublas -std c++17 -o task1

# ./task1 1000 10

for i in {5..14}
do
    echo "Now N = $[2**$i]"
    ./task1 $[2**$i] 25
done