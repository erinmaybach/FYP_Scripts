#!/bin/bash
#SBATCH --account=XXXX
#SBATCH --job-name=db_profile_sum
#SBATCH --partition=RM-shared
#SBATCH --time=24:00:00
#SBATCH --ntasks-per-node=64
#SBATCH --output=db_profile_sum_%j.txt
#SBATCH --error=db_profile_sum_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXXX

module load anaconda3

# Build contig database
conda activate /XXXX/.conda/envs/anvio-8_env
anvi-gen-contigs-database -f contigs.fa \
  -o contigs.db \
  -n "DMOG_SPAC"

# Evaluate completeness
anvi-run-hmms -c contigs.db \
  -I Bacteria_71  \
  -T 64

# Functional annotation
anvi-setup-ncbi-cogs -T 64 \
  --just-do-it
anvi-run-ncbi-cogs -c contigs.db  \
  -T 64
anvi-get-sequences-for-gene-calls -c contigs.db \
  -o gene_calls.fa
conda deactivate

# Taxonomy with Centrifuge
conda activate /XXXX/.conda/envs/centrifuge_env
centrifuge -f \
  -x /XXXX/15DMOG_NPAC_mgx/centrifuge_dbs/p+h+v gene_calls.fa \
  -S centrifuge_hits.tsv
conda deactivate

conda activate /XXXX/.conda/envs/anvio-8_env
anvi-import-taxonomy-for-genes -c contigs.db \
  -i centrifuge_report.tsv centrifuge_hits.tsv \
  -p centrifuge

# Build individual sample profiles, then merge them into 1
for i in $(cat samples.txt)
do
  anvi-profile -i "$i".bam \
  -c contigs.db \
  -T 64
done
anvi-merge */PROFILE.db \
  -o DMOG_SPAC \
  -c contigs.db

# Import bin collection file
anvi-import-collection collection.tsv \
  -p DMOG_SPAC/PROFILE.db \
  -c contigs.db \
  -C "MaxBin2" \
  --contigs-mode

# Export the splits version of the bin collection
anvi-export-collection \
  -C MaxBin2 \
  -p DMOG_SPAC/PROFILE.db \
  --include-unbinned
conda deactivate

# Create a file to order contigs (splits version) by bin assignment
awk '$1 ~ /^c_/ {print $1}' collection-MaxBin2.txt > order-items.txt

# Import the order file
conda activate /XXXX/.conda/envs/anvio-8_env
anvi-import-items-order \
  -p DMOG_SPAC/PROFILE.db \
  -i order-items.txt \
  --name MaxBin2Order

# Import taxonomy
anvi-run-scg-taxonomy \
  -c contigs.db

# Generate profile summary
anvi-summarize -c contigs.db \
  -p DMOG_SPAC/PROFILE.db \
  -o DMOG_SPAC_SUMMARY \
  -C MaxBin2
conda deactivate
