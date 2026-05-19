#!/bin/bash
#SBATCH --job-name=pluc_sex_multiqc
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint='douglas&256gb'
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive
#SBATCH --time=240:00:00
#SBATCH -e %j.err
#SBATCH -o %j.out

module purge
source ~/miniconda3/etc/profile.d/conda.sh

STORAGE="/storage/mussmann/dx_projects/dxCPMSex"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="multiqc"

OUTDIR="pre-trim"

INDIR="$STORAGE/raw/usfishwildli-smcgc-sm-27682-O8rWid43Bn-r7l2v"

PROC=16

mkdir -p $SCRATCH/$PROGRAM/$OUTDIR/

cd $SCRATCH/$PROGRAM/$OUTDIR/

# run fastqc
#conda activate fastqc0119
#fastqc -t $PROC $INDIR/Pluc*.gz

# run multiqc
cd $INDIR
conda activate multiqc113
multiqc ./
mkdir -p $STORAGE/$PROGRAM/$OUTDIR
rsync -r $SCRATCH/$PROGRAM/$OUTDIR $STORAGE/$PROGRAM/$OUTDIR/.

exit
