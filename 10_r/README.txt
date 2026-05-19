The code in this folder was modified from code at https://github.com/johanzi/gwas_gemma/blob/master/gemma_analysis.Rmd

Some of the column headers in the sex_mod_sub_map.sex.txt_tmp.assoc.txt file produced by vcf2gwas needed renaming (often converting lower-case to upper-case) for this code to work. The `reformat.sh` script contains these commands.

The code in `gwas.R` was used to produce manhattan plots. Code in `dx2502_qpcr.R` was used to make allelic discrimination plots for the TaqMan assay.
