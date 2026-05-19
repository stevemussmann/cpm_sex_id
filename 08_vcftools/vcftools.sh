#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate wgs

VCF="cpmSex.vcf"

vcftools --vcf $VCF --keep-only-indels --recode --recode-INFO-all --out cpm-wgs_indels-only
vcftools --vcf $VCF --remove-indels --recode --recode-INFO-all --out cpm-wgs_snps-only

exit
