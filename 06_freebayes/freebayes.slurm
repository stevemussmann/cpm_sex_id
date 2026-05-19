#!/bin/bash
#SBATCH --job-name=pluc_freebayes
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint='douglas&768gb'
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --exclusive
#SBATCH --time=240:00:00
#SBATCH -e %j.err
#SBATCH -o %j.out

source ~/miniconda3/etc/profile.d/conda.sh
conda activate wgs

PROC=32

STORAGE="/storage/mussmann/dx_projects/dxCPMSex"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="freebayes"
BAMLIST="bams.list"
VCF="cpmSex.vcf"

# location and name of genome
GENOMEDIR="/storage/mussmann/dx_projects/dx2206/current_draft"
FASTA="pluc_hic_genome.3ddna.clean.nocontamination.renamed.fa"

# location of bams
RAW="$STORAGE/picard"

# make directory
mkdir -p $SCRATCH/$PROGRAM

# copy files
rsync $GENOMEDIR/$FASTA $SCRATCH/$PROGRAM/.
rsync $RAW/*.nodup.bam $SCRATCH/$PROGRAM/.
rsync $RAW/*.nodup.bam.bai $SCRATCH/$PROGRAM/.

# change directories into scratch
cd $SCRATCH/$PROGRAM

# check if index file exists for bam; make index if it does not
for BAM in *.nodup.bam
do
	if [ -f ${BAM}.bai ]
	then
		echo "Index exists for $BAM"
	else
		samtools index $BAM
	fi
done

# index fasta
samtools faidx $FASTA

# make bam list
ls *.nodup.bam > $BAMLIST

# run freebayes
freebayes-parallel <(fasta_generate_regions.py ${FASTA}.fai 1000000) $PROC \
	--min-mapping-quality 30 --min-base-quality 20 --min-alternate-fraction 0.35 \
	--min-coverage 10 --use-mapping-quality --genotype-qualities \
	-f $FASTA --bam-list $BAMLIST > $VCF

# cleanup
rm *.bam

# copy files to storage
mkdir -p $STORAGE/$PROGRAM
rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit
