# Colorado Pikeminnow Sex Identification
Scripts used for conducting genome resequencing and GWAS to identify sex-determining loci in the Colorado Pikeminnow genome

## Description
These scripts were utilized for analyses described in the following publication:

Manuscript in prep.

Upon manuscript acceptance, the raw DNA sequence data will become available in the NCBI Sequence Read Archive (SRA) under BioProject PRJNA1379135. Associated data files will be provided on the Open Science Framework (DOI: 10.17605/OSF.IO/Y7AJ4). 

## Documentation
Folders in this repository are numbered with prefixes indicating order of operations. Scripts within folders also follow this naming convention to indicate order of operations, if necessary. 

Occasional exceptions to these naming conventions occur when a script or other provided input file is called by a numbered script. Rarely, an analysis was unable to be scripted. These exceptions are documented using README.md files which appear in the relevant subfolders of this repository.

## Conda Environments
I used the following commands to create conda environments used in these scripts:
```
# conda command to create wgs environment
conda create -n wgs -c conda-forge -c bioconda trim-galore=0.6.10 bowtie2=2.5.4 samtools=1.22 bcftools=1.22 vcftools=0.1.17 picard=3.4.0 freebayes=1.3.10 pandas

# conda command to install vcf2gwas
conda create -n vcf2gwas -c conda-forge -c bioconda -c fvogt257 vcf2gwas
```
