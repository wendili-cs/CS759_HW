#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task1_cub
#SBATCH --output=task1_cub.out
#SBATCH --error=task1_cub.err
#SBATCH --time=0-00:10:00
#SBATCH --gres=gpu:1

# module load nvidia/cuda gcc/9.4.0

rm -rf build
mkdir build
cd build
nvcc ../task1_cub.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o task1_cub

# ./task1_cub 1000

for i in {10..30}
do
    echo "Now N = $[2**$i]"
    ./task1_cub $[2**$i]
done