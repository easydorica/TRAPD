#!/bin/bash
#SBATCH --partition=prod
#SBATCH --job-name=thc_coverage
#SBATCH --account federica.isidori
#SBATCH --mem=39G
#SBATCH --time=INFINITE
#SBATCH --ntasks=10
#SBATCH --nodes=1  # not really useful for not mpi jobs
#SBATCH --mail-type=END ## BEGIN, END, FAIL or ALL
#SBATCH --mail-user=federica.isidori2@unibo.it
#SBATCH --error="/work/federica.isidori/THC_2022/thc_dp10.err"
#SBATCH --output="/work/federica.isidori/THC_2022/thc_dp10.out"

source /shared/conda/miniconda3/bin/activate
#conda activate /home/federica.isidori/.conda/envs/samtools
#java -Xmx70G -jar /opt/miniconda2/envs/gatk3/opt/gatk-3.8/GenomeAnalysisTK.jar -T DepthOfCoverage -R /archive/ngsbo/db/trioCEU_1KGP_resources/GRCh38_full_analysis_set_plus_decoy_hla.fa -L /archive/ngsbo/db/regions/gencode.hg38.v35.protein_coding.CDS.extended.bed -I /lts/archive-r/THC_2022/bam.list --omitIntervalStatistics --omitLocusTable --minBaseQuality 0 --minMappingQuality 20 --includeRefNSites --countType COUNT_FRAGMENTS -o /work/federica.isidori/THC_2022/cases.counts.txt

#cd /lts/archive-r/THC_2022/
#samtools depth -a -H --min-MQ 20 -b /archive/ngsbo/db/regions/gencode.hg38.v35.protein_coding.CDS.extended.bed -f /lts/archive-r/THC_2022/bam1.list > /work/federica.isidori/THC_2022/samtools.depth.txt

conda activate /opt/miniconda2/envs/ngsra
zcat /work/federica.isidori/THC_2022/samtools.depth.txt.gz | tail -n+2 | awk '{count=0} {for(i=3; i<1000; i++) if($i>10) count++} {if(count>0.9) print $1"\t"($2-1)"\t"$2}' | bedtools merge -i stdin > /work/federica.isidori/THC_2022/cases71.dp10.bed