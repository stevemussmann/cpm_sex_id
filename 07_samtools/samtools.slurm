#!/bin/bash
#SBATCH --job-name=pluc_samtools_coverage
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint='douglas&256gb'
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive
#SBATCH --time=480:00:00
#SBATCH -e %j.err
#SBATCH -o %j.out

module purge
source ~/miniconda3/etc/profile.d/conda.sh
conda activate wgs

PROC=16

STORAGE="/storage/mussmann/dx_projects/dxCPMSex"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="samtools_coverage"

mkdir -p $SCRATCH/$PROGRAM

RAW="$STORAGE/picard"

rsync $RAW/*.nodup.bam $SCRATCH/$PROGRAM/.
rsync $RAW/*.nodup.bam.bai $SCRATCH/$PROGRAM/.

cd $SCRATCH/$PROGRAM

# coverage bam
for BAM in *.nodup.bam
do
	if [ -f ${BAM}.bai ]
	then
		echo "Index exists for $BAM"
	else
		samtools index $BAM
	fi
	samtools coverage $BAM > ${BAM}.coverage.stats
	samtools coverage -A -w 100 $BAM > ${BAM}.coverage.histogram
	samtools coverage -m --plot-depth -w 100 -A $BAM > ${BAM}.depth.histogram
done

rm *.nodup.bam
rm *.nodup.bam.bai

mkdir -p $STORAGE/$PROGRAM
rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit

