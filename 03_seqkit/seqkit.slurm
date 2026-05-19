#!/bin/bash
#SBATCH --job-name=pluc_seqkit
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
conda activate seqkit

STORAGE="/storage/mussmann/dx_projects/dxCPMSex"
PROGRAM="trimgalore_genome_sex/trimmed"

cd $STORAGE/$PROGRAM

OUT="seqkit.stats.txt"

seqkit stats -a *_val_*.fq.gz -o $OUT

exit
