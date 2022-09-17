process TECOUNT {
    cpus 4
    memory '16 GB'
    publishDir "${params.outdir}/${sample}/tecount", mode: 'copy'
    conda '/home/eidgah/miniconda3/envs/tecount'

    input:
    tuple val(sample), path(bam)
    path rmsk

    output:
    tuple val(sample), path('*.count.txt'), emit: counts
    path '*version.txt', emit: version

    script:
    """
    samtools index -@ ${task.cpus} ${bam}
    TEcount --version | sed 's/TEcount //' > tecount.version.txt
    TEcount \\
      -b ${bam} \\
      -r ${rmsk} \\
      --overlap 10 \\
      --threads ${task.cpus}
    """
}


