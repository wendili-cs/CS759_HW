#!/usr/bin/env zsh
#SBATCH -p wacc
#SBATCH --job-name=hw1task6
#SBATCH --output=task6.out
#SBATCH --error=task6.err
#SBATCH --time=0-00:01:00
#SBATCH -c 2

mkdir build
cd build
g++ ../task6.cpp -Wall -O3 -std=c++17 -o task6
./task6 6