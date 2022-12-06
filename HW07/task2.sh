#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task2
#SBATCH --output=task2.out
#SBATCH --error=task2.err
#SBATCH --time=0-00:10:00
#SBATCH --gres=gpu:1

# module load nvidia/cuda gcc/9.4.0

rm -rf build
mkdir build
cd build
nvcc ../task2.cu ../count.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o task2

# ./task2 1000

for i in {5..24}
do
    echo "Now N = $[2**$i]"
    ./task2 $[2**$i]
done