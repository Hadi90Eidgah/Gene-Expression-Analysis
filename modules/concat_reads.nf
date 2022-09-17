process CONCAT_READS_SE {
    tag "${name}"
    cpus 2
    memory '100 MB'

    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), path("${name}.fastq.gz")

    script:

    if (reads instanceof List && reads.size() > 1)
    """
    zcat ${reads} | gzip > ${name}.fastq.gz
    """

    else
    """
    mv ${reads} ${name}.fastq.gz
    """
}

process CONCAT_READS {
    cpus 2
    memory '1 GB'

    input:
    tuple val(name), path(reads), path(mates)

    output:
    tuple val(name), path("${name}_R{1,2}.fastq.gz")

    script:
    if (reads instanceof List && reads.size() > 1)
    """
    zcat ${reads} | gzip > ${name}_R1.fastq.gz
    zcat ${mates} | gzip > ${name}_R2.fastq.gz
    """

    else
    """
    mv ${reads} ${name}_R1.fastq.gz
    mv ${mates} ${name}_R2.fastq.gz
    """
}

