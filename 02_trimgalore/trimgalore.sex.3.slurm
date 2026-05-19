#!/bin/bash
#SBATCH --job-name=pluc_trimgalore_3
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
conda activate trimgalore067

STORAGE="/storage/mussmann/dx_projects/dxCPMSex"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="trimgalore_genome_sex"

FILT="$STORAGE/raw/usfishwildli-smcgc-sm-27682-O8rWid43Bn-r7l2v"

PROC=16

mkdir -p $SCRATCH/$PROGRAM/trimmed

for file in `cat /home/mussmann/data/pluc/dxCPMsex.list.3.txt`
do
	rsync $FILT/$file $SCRATCH/$PROGRAM/.
done

cd $SCRATCH/$PROGRAM

# run Trimgalore
for file1 in *R1_001.fastq.gz
do
	file2="${file1%R1_001.fastq.gz}R2_001.fastq.gz"
	trim_galore -j $PROC --paired --retain_unpaired --output_dir $SCRATCH/$PROGRAM/trimmed $file1 $file2

	rm $file1
	rm $file2
done

mkdir -p $STORAGE/$PROGRAM

rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit
