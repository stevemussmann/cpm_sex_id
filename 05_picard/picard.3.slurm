#!/bin/bash
#SBATCH --job-name=pluc_picard_3
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint='douglas&256gb'
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive
#SBATCH --time=240:00:00
#SBATCH -e %j.err
#SBATCH -o %j.out

source ~/miniconda3/etc/profile.d/conda.sh
conda activate wgs

PROC=16

STORAGE="/storage/mussmann/dx_projects/dxCPMSex"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="picard"

RAW="$STORAGE/bowtie2"

BAMLIST="bamlist.3.txt"

mkdir -p $SCRATCH/$PROGRAM

cd $SCRATCH/$PROGRAM

# counter for adding read group to bam files
COUNT=41

# mark duplicates
for file in `cat $SLURM_SUBMIT_DIR/$BAMLIST`
do
	# get basename of bam file to insert into read group
	BAM="$(basename -- $file)"	
	NAME=${BAM%.bam}

	# add read group so picard can read bam files
	samtools addreplacerg -r "@RG\tID:${COUNT}\tSM:${NAME}\tPL:Illumina\tLB:${NAME}.fa" -o $SCRATCH/$PROGRAM/$BAM $file
	COUNT=$(($COUNT+1)) # increment read group counter

	# check if index file exists for bam; make index if it does not
	if [ -f $SCRATCH/$PROGRAM/$BAM.bai ]
	then
		echo "Index exists for $SCRATCH/$PROGRAM/$BAM.bai"
	else
		samtools index $SCRATCH/$PROGRAM/$BAM
	fi

	# remove pcr duplicates
	picard -Xmx64g MarkDuplicates ASSUME_SORT_ORDER=coordinate VALIDATION_STRINGENCY=SILENT \
		INPUT=$SCRATCH/$PROGRAM/$BAM OUTPUT=$SCRATCH/$PROGRAM/${NAME}.nodup.bam \
		METRICS_FILE=$SCRATCH/$PROGRAM/${NAME}.nodup.bam.metrics \
		>& $SCRATCH/$PROGRAM/${NAME}.MarkDuplicates.log
done

mkdir -p $STORAGE/$PROGRAM
rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit
