#!/bin/bash
#SBATCH --partition=prod
#SBATCH --job-name=
#SBATCH --account 
#SBATCH --mem=39G
#SBATCH --time=INFINITE
#SBATCH --ntasks=10
#SBATCH --nodes=1  # not really useful for not mpi jobs
#SBATCH --mail-type=END ## BEGIN, END, FAIL or ALL
#SBATCH --mail-user=
#SBATCH --error=""
#SBATCH --output=""

source /shared/conda/miniconda3/bin/activate
conda activate /home/federica.isidori/.conda/envs/samtools


#cd /lts/archive-r/THC_2022/
samtools depth -a -H --min-MQ 20 -b /archive/ngsbo/db/regions/gencode.hg38.v35.protein_coding.CDS.bed -f /lts/archive-r/THC_2022/bam1.list > /work/federica.isidori/THC_2022/samtools.depth.txt

conda activate /opt/miniconda2/envs/ngsra
gzip samtools.depth.txt

zcat /work/federica.isidori/THC_2022/samtools.depth.txt.gz | tail -n+2 | awk '{count=0} {for(i=3; i<1000; i++) if($i>10) count++} {if(count>0.9) print $1"\t"($2-1)"\t"$2}' | bedtools merge -i stdin > /work/federica.isidori/THC_2022/cases71.dp10.bed
