process STAR_ALIGN {
  cpus 8
  memory '35 GB'
  publishDir "${params.outdir}/${sample}/star", mode: 'copy'

  input :
  path star
  path gtf 
  tuple val(sample), path(reads)

  output:
  tuple val(sample), path('*.out.bam'), emit: aligned
  path '*Log.final.out', emit: mqc
  path '*.{out,out.tab}'

  script:

  """
  STAR \\
  --runMode alignReads \\
  --runThreadN 12 \\
  --genomeDir ${star} \\
  --sjdbGTFfile ${gtf} \\
  --readFilesCommand zcat \\
  --readFilesIn ${reads} \\
  --genomeLoad NoSharedMemory \\
  --outSAMtype BAM SortedByCoordinate \\
  --outFilterIntronMotifs RemoveNoncanonicalUnannotated \\
  --outFilterScoreMinOverLread 0.5 \\
  --outFilterMatchNminOverLread 0.3 \\
  --winAnchorMultimapNmax 100 
  """

}
