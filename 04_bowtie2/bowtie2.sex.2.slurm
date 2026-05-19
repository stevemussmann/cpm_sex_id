#!/bin/bash
#SBATCH --job-name=pluc_bowtie2_sex_2
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
PROGRAM="bowtie2"

FASTA="pluc_hic_genome.3ddna.clean.nocontamination.renamed.fa"
DB="pluc"

GENOME="/storage/mussmann/dx_projects/dx2206/current_draft/$FASTA"
RAW="$STORAGE/trimgalore_genome_sex/trimmed"

mkdir -p $SCRATCH/$PROGRAM

# copy fastq files
FLIST="${SLURM_SUBMIT_DIR}/dxCPMsex.list.bowtie2.2.txt"
for file in `cat $FLIST`
do
	rsync $RAW/$file $SCRATCH/$PROGRAM/.
done

# copy genome
rsync $GENOME $SCRATCH/$PROGRAM/.

cd $SCRATCH/$PROGRAM

#index the genome
bowtie2-build --threads $PROC $FASTA $DB

#align reads
for file in *_R1_001_val_1.fq.gz
do
	read1=$file
	read2="${file%_R1_001_val_1.fq.gz}_R2_001_val_2.fq.gz"

	sam="$(basename -- $read1)"
	sam=${sam%_S*}.sam

	bowtie2 -p $PROC -x $DB --very-sensitive -1 $read1 -2 $read2 -S $sam

	rm $read1
	rm $read2
	
	samtools view -bS $sam > ${sam%.sam}_unsorted.bam
	rm $sam

	samtools sort -@ $PROC -o ${sam%.sam}.bam ${sam%.sam}_unsorted.bam
	rm ${sam%.sam}_unsorted.bam

	samtools stats ${sam%.sam}.bam > ${sam%.sam}.bam.stats
done

rm $SCRATCH/$PROGRAM/$FASTA

mkdir -p $STORAGE/$PROGRAM
rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit

