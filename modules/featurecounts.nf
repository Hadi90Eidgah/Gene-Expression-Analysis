process FEATURECOUNTS {
    cpus 4
    memory '8 GB'
    publishDir "${params.outdir}/${sample}/featureCounts_TE_rmsk", mode: 'copy'

    input:
    path gtf
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path('*.{txt,summary}'), emit: fea_count

    script:
    """
     featureCounts \\
      -M \\
      -F GTF \\
      -T ${task.cpus} \\
      -s 0 \\
      -p \\
      --donotsort \\
      -a ${gtf} \\
      -o ${sample}_outfeatureCounts.txt \\
      ${bam}
    """
}


