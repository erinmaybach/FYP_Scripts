#!/bin/bash
#SBATCH --account=XXXX
#SBATCH --job-name=trim
#SBATCH --partition=RM-shared
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --output=trim_%j.txt
#SBATCH --error=trim_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXXX

module load anaconda3
conda activate /XXXX/.conda/envs/project_1/

for sample in $(cat samples.txt)
do
  sickle pe \
   -f rawreads/"$sample"_1.fastq \
   -r rawreads/"$sample"_2.fastq \
   -t sanger \
   -o trimmedreads/"$sample"_trimmed_1.fastq \
   -p trimmedreads/"$sample"_trimmed_2.fastq \
   -s trimmedreads/"$sample"_singletons.fastq
done

conda deactivate
