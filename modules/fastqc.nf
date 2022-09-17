process FASTQC {
    cpus 4
    memory '4 GB'
    publishDir "${params.outdir}/${sample}/fastqc", mode:'copy'

    input:
    tuple val(sample), path(reads)

    output:
    path '*_fastqc.{zip,html}'
    path '*_fastqc.zip', emit: mqc

    script:
    """
    fastqc -t ${task.cpus} ${reads}
    """
}
