
#!/bin/sh
#SBATCH --account=bio210078p
#SBATCH --job-name=Sickle_npac
#SBATCH --partition=RM-shared
#SBATCH --time=04:00:00
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-user=emaybach@ldeo.columbia.edu

module load anaconda3
cd /oceans/project/bio210078p/emaybach/MetaG_2015/01_RawReads_npac
source activate bioconda

sickle pe -f FischkornScope22March16_TAGCTT_R1_002.fastq -r FischkornScope22March16_TAGCTT_R2_002.fastq -t sanger -o ../02_TrimmedReads/npac1_trimmed_R1.fq -p ../02_TrimmedReads/npac1_trimmed_R2.fq -s ../02_TrimmedReads/npac1_trimmed_singles.fq

conda deactivate
