# FYP_Scripts
Catch all repository for scripts used in FYP<br>
Some identifying information redacted 
## Downloading raw reads from SRA
**download_sra_fastq**: script for downloading SRA files and converting to raw read fastq files using the SRAtoolkit 
## Trimming 
**Sickle_trim.sh**: script for trimming of 15DMOG_NPAC with Sickle<br>
**trim.sh**: script used for trimming samples using a sample.txt file 
## Assembly 
**megahitasmbl.sh**: script for the co-assembly of 15DMOG_SPAC samples with Megahit
## Multi-step pipelines
**clean_map_bin_check.sh**: There are 7 parts of this script. 1) Anvio changes contig names to eliminate any characters anvi’o doesn’t like and filters out contigs shorter than 1000 bps. 2) Bowtie2 builds the assembly index), Samtools maps, indexes and converts SAM files to BAM files. 4) Trimmed reads are concatenated for each sample into one and a text file is produced listing the cat reads (catTCL3). 5) Maxbin runs bowtie2 and searches for marker genes to initiate binning and then bins. 6) A new folder is created for the bin fasta files, and the maxbin fasta files are moved into this directory, bins/. 7) CheckM evaluates the quality of the bins MaxBin produced.

**db_profile_sum.sh**: There are 11 parts to this script. 1) Anvio generates “contigs.db” from “contigs.fa”. 2) HMMER scans for SCGs and evaluates completeness through anvio. 3) Functional annotation with NCBI COGs and BLAST via anvio 4) Taxonomic assignment with centrifuge and Anvio. 5) Individual sample profiles are built and merged into 1. 6) The MaxBin collection is imported into the merged profile. 7) Bin Collection is exported in splits format. 8) A file is created to order items in the profile by their bin assignment. 9) Taxonomy is run for the bins. 10) The order items file is imported into the profile. 11) A summary folder is created for the bin collection of the profile.
