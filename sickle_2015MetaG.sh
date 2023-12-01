##### Need to change Slurm script to match appropriate HPC login info

#!/bin/sh
#SBATCH --account=dsi
#SBATCH --job-name=xSickleNpac
#SBATCH --mem=128GB
#SBATCH --time=04:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=arr47@columbia.edu

module load anaconda
cd /rigel/dsi/users/arr47/redoTrichoMag/01_RawReads
source activate bioconda

#sickle pe -f FischkornScope22March16_TAGCTT_R1_002.fastq -r FischkornScope22March16_TAGCTT_R2_002.fastq -t sanger -o ../02_TrimmedReads/npac1_trimmed_R1.fq -p ../02_TrimmedReads/npac1_trimmed_R2.fq -s ../02_TrimmedReads/npac1_trimmed_singles.fq

conda deactivate
