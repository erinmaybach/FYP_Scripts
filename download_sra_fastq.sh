#!/bin/bash
#SBATCH --account=XXXX
#SBATCH --job-name=downloadfastq
#SBATCH --partition=RM-shared
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --output=downloadfastq_%j.txt
#SBATCH --error=downloadfastq_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXXX

module load sra-toolkit/2.10.9

vdb-config --prefetch-to-cwd

for sample in $(cat samples.txt)
do
   prefetch "$sample" --max-size u
   fastq-dump "$sample" --split-3 --skip-technical
done
