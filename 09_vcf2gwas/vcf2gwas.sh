#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate wgs

VCF="cpm-wgs_snps-only.vcf"
MAP="map.sex.txt"

bcftools annotate -x 'INFO/NUMALT' $VCF > ${VCF%.vcf}.annotate.vcf

conda activate vcf2gwas
vcf2gwas -v ${VCF%.vcf}.annotate.vcf -pf $MAP -ap -lmm

exit
