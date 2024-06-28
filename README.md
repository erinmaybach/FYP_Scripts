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
**clean_map_bin_check.sh**: This script achieves the following consecutive actions for 15DMOG_SPAC assembled contigs: cleaning contig names and filtering short sequences with Anvo'o, mapping with BowTie2, indexing and sorting BAM files with Samtools, concatenating reads for binning, binning with MaxBin2, and QC of bins with CheckM 

