process FASTP {
    cpus 8
    memory '4 GB'
    publishDir "${params.outdir}/${sample}/fastp", mode: 'copy'

    input:
    tuple val(sample), path(read1), path(read2)

    output:
    tuple val(sample), path('*.trimmed.fastq.gz'), emit: trimmed
    path '*.json', emit: json
    path '*.html', emit: html
    path 'fastp.version.txt', emit: version

    script:
    """
     fastp --version 2>&1 | sed -e "s/fastp //g" > fastp.version.txt
     fastp \\
      --in1 ${read1} \\
      --in2 ${read2} \\
      --out1 ${sample}_R1.trimmed.fastq.gz \\
      --out2 ${sample}_R2.trimmed.fastq.gz \\
      --thread ${task.cpus}
    """
}

      
