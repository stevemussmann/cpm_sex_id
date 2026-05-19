#!/bin/bash

FILE="sex_mod_sub_map.sex.59.txt_cpmSex59_snps-only.anno.assoc.txt"
OUT="cpmSex.assoc.txt"

# add new header line
echo -e "CHR\tSNP\tBP\tn_miss\tallele1\tallele0\taf\tbeta\tse\tlogl_H1\tl_remle\tP" > $OUT

# copy all lines except old header to new file
tail -n +2 $FILE >> $OUT

# strip Chromosome_ identifier
sed -i 's/Chromosome_//g' $OUT

# remove unplaced scaffolds
grep -v Unplaced_scaffold_ $OUT > tmp
mv tmp $OUT

# manhattan plot can't log transform 0 P values. Change all to 0.000001e+00 for plotting purposes
#sed -i 's/0.000000e+00/0.000000e+00/g' $OUT

exit
