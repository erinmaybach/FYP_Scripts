#!/bin/bash
#SBATCH --account=XXXX
#SBATCH --job-name=anviocollect
#SBATCH --partition=RM-shared
#SBATCH --time=05:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXXX

FILES=$(find *.fasta)
for f in $FILES; do
 NAME=$(basename $f .fasta)
 grep ">" $f | sed 's/>//' | sed -e "s/$/\t$NAME/" | sed 's/\./_/' >> collection.tsv
done
