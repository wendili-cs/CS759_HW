#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH --job-name=hw2task1
#SBATCH --output=hw2task1.out
#SBATCH --error=hw2task1.err
#SBATCH --time=0-00:05:00
#SBATCH -c 4

rm -rf build
mkdir build
cd build
# g++ ../scan.cpp ../task1.cpp -mcmodel=medium -Wall -O3 -std=c++17 -o task1
g++ ../scan.cpp ../task1.cpp -Wall -O3 -std=c++17 -o task1

for i in {10..30}
do
    echo "Now n = $[2**$i]"
    ./task1 $[2**$i]
done