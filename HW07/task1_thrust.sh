#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=task1_thrust
#SBATCH --output=task1_thrust.out
#SBATCH --error=task1_thrust.err
#SBATCH --time=0-00:10:00
#SBATCH --gres=gpu:1

# module load nvidia/cuda gcc/9.4.0

rm -rf build
mkdir build
cd build
nvcc ../task1_thrust.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o task1_thrust

# ./task1_thrust 1000

for i in {10..30}
do
    echo "Now N = $[2**$i]"
    ./task1_thrust $[2**$i]
done