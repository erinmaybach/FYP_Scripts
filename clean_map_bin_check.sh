#!/bin/bash
#SBATCH --account=bio210078p
#SBATCH --job-name=clean_map_bin_check
#SBATCH --partition=RM-shared
#SBATCH --time=24:00:00
#SBATCH --ntasks-per-node=64
#SBATCH --output=clean_map_bin_check_%j.txt
#SBATCH --error=clean_map_bin_check%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emaybach@ldeo.columbia.edu

module load anaconda3

# Clean contig names and filter out short contigs
conda activate /ocean/projects/bio210078p/emaybach/.conda/envs/anvio-8_env
anvi-script-reformat-fasta assembly/final.contigs.fa \
  -o contigs.fa \
  -l 1000 \
  --simplify-names
conda deactivate

# Map with bowtie
conda activate /ocean/projects/bio210078p/emaybach/.conda/envs/bowtie_env
bowtie2-build contigs.fa index
for sample in $(cat samples.txt)
do
  bowtie2 -x index -q -1 trimmedreads/"$sample"_trimmed_1.fastq \
  -2 trimmedreads/"$sample"_trimmed_2.fastq \
  --no-unal -p 64 -S "$sample".sam
done
conda deactivate

# Index and convert to BAM
conda activate /ocean/projects/bio210078p/emaybach/.conda/envs/samtools_env
for sample in $(cat samples.txt)
do
  samtools view -b -o "$sample"-raw.bam "$sample".sam
  samtools sort -o "$sample".bam "$sample"-raw.bam
  samtools index "$sample".bam
done
conda deactivate

# Concatenate forward and reverse reads in trimmedreads/ and list the merged files in  the file catSPAC
for sample in $(cat samples.txt)
do
  cat trimmedreads/"$sample"_trimmed_1.fastq trimmedreads/"$sample"_trimmed_2.fastq > "$sample"_trimmed.fq
  echo "$sample"_trimmed.fq >> catSPAC
done

# Run MaxBin on the concatenated reads listed in catSPAC
conda activate /ocean/projects/bio210078p/emaybach/.conda/envs/maxbin2_env
run_MaxBin.pl -contig contigs.fa \
  -reads_list catSPAC \
  -out SPAC \
  -thread 64
conda deactivate

# Move bin fasta files into the folder bins/
mkdir bins/
mv SPAC.*.fasta bins/

# Run CheckM on the bins created by MaxBin
conda activate /ocean/projects/bio210078p/emaybach/.conda/envs/checkm
export PATH=/ocean/projects/bio210078p/emaybach/.conda/envs/checkm/bin:$PATH
export CHECKM_DATA_PATH=/ocean/projects/bio210078p/emaybach/.conda/envs/checkm/database
echo ${CHECKM_DATA_PATH} | checkm data setRoot ${CHECKM_DATA_PATH}
checkm lineage_wf -t 64 -x fasta bins/ checkm_maxbin
conda deactivate
