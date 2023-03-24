## Creating read depth filter (Step 0.4) 
As several users have requested our approach for read depth filtering, we have included code for how we filtered for sites with > 90% of samples having DP > 10

We calculate read depth for case samples using "source /shared/conda/miniconda3/bin/activate
#conda activate /home/federica.isidori/.conda/envs/samtools
#java -Xmx70G -jar /opt/miniconda2/envs/gatk3/opt/gatk-3.8/GenomeAnalysisTK.jar -T DepthOfCoverage -R /archive/ngsbo/db/trioCEU_1KGP_resources/GRCh38_full_analysis_set_plus_decoy_hla.fa -L /archive/ngsbo/db/regions/gencode.hg38.v35.protein_coding.CDS.extended.bed -I /lts/archive-r/THC_2022/bam.list --omitIntervalStatistics --omitLocusTable --minBaseQuality 0 --minMappingQuality 20 --includeRefNSites --countType COUNT_FRAGMENTS -o /work/federica.isidori/THC_2022/cases.counts.txt

#cd /lts/archive-r/THC_2022/
#samtools depth -a -H --min-MQ 20 -b /archive/ngsbo/db/regions/gencode.hg38.v35.protein_coding.CDS.extended.bed -f /lts/archive-r

GATK (v3.4): java -jar GATK.jar -T DepthOfCoverage -I bam.list -R human_g1k_v37.fasta --omitIntervalStatistics --omitLocusTable --minBaseQuality 0 --minMappingQuality 20 --includeRefNSites --countType COUNT_FRAGMENTS -o cases.counts.txt

In analogous fashion to above, we then created a bed file for the cases containing only positions with > 90% of samples with DP > 10: zcat cases.counts.txt.gz | tail -n+2 | awk '{count=0} {for(i=4; i<1000; i++) if($i>10) count++} {if(count>0.9) print $1}' | awk -F":" '{print $1"\t"($2-1)"\t"$2}' | bedtools merge -i stdin > cases.dp10.bed

Finally, we intersected the case and control bed files to get only positions meeting criteria for both datasets. bedtools intersect -a gnomad.dp10.bed -b cases.dp10.bed | sort -k1,1n -k2,2n | bedtools merge -i stdin > combined.dp10.bed
