#!/bin/bash
#SBATCH --account=bio210078p
#SBATCH --job-name=megahitasmbl
#SBATCH --partition=RM-shared
#SBATCH --time=72:00:00
#SBATCH --ntasks-per-node=64
#SBATCH --output=megahitasmbl_%j.txt
#SBATCH --error=megahitasmbl_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emaybach@ldeo.columbia.edu

module load anaconda3
conda activate /ocean/projects/bio210078p/emaybach/.conda/envs/project_1/

megahit -1 trimmedreads/SRR7822613_trimmed_1.fastq,trimmedreads/SRR7822620_trimmed_1.fastq,trimmedreads/SRR7822621_trimmed_1.fastq \
  -2 trimmedreads/SRR7822613_trimmed_2.fastq,trimmedreads/SRR7822620_trimmed_2.fastq,trimmedreads/SRR7822621_trimmed_2.fastq \
  -r trimmedreads/SRR7822613_singletons.fastq,trimmedreads/SRR7822620_singletons.fastq,trimmedreads/SRR7822621_singletons.fastq \
  -o assembly

conda deactivate
