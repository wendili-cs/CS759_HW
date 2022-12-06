#!/usr/bin/env zsh
#SBATCH -p wacc
#SBATCH --job-name=FirstSlurm
#SBATCH --output=FirstSlurm.out
#SBATCH --error=FirstSlurm.err
#SBATCH --time=0-00:01:00
#SBATCH -c 2

echo "hostname of the machine:"
hostname