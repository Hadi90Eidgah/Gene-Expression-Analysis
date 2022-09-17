// Enable DSL2
nextflow.enable.dsl = 2
/*
  ----------------------------------------------------------------------------
                       Main Nextflow script:
*/

log.info """\

    Gene Expr. Analysis Main Workflow
    ================================================================
    Genome assembly: ${params.genome}
    reads          : ${params.input}
    outdir         : ${params.outdir}

    """
    .stripIndent()

include {CONCAT_READS} from './modules/concat_reads'
include {FASTP} from './modules/fastp'
include {BBDUK} from './modules/bbduk'
include {FASTQC} from './modules/fastqc'
include {FASTQSCREEN} from './modules/fastqscreen'
include {STAR_ALIGN} from './modules/star_align'
include {TECOUNT} from './modules/tecount'
include {MULTIQC} from './modules/multiqc'
workflow{
    reads = Channel
        .fromPath('~.//pipeline/tecount_immune.csv')  //CSV header: name,fastq[,fastq2],strandness
        .splitCsv(header: true)
        .tap { ch_samplesheet } //
        .map { sample ->
             [ sample.name, file(sample.fastq), file(sample.fastq2) ]
         }
        .groupTuple()

    samplesheet = [:]
    ch_samplesheet.subscribe { sample ->
        samplesheet.put(
            sample.name,
            [
                'name': sample.name,
                'strandness': sample.strandness
            ]
        )
    }

rRNAs= '~/pipeline/assets/human_ribosomal.fa'
fastqscreen_conf = '~/pipeline/conf/fastq_screen.config'
gtf='/refrences/gencode.v41.pri.ucsc.names.gtf'
star = '/Project/GRCh38/star/STAR276a'
rmsk= '/GRCh38/repeatmasker/rmsk_hg38_open-4.0.3-20130422.bed.gz'

FASTP(reads)
BBDUK(FASTP.out.trimmed,rRNAs)
FASTQC(BBDUK.out.bbduk_out)
FASTQSCREEN(BBDUK.out.bbduk_out,fastqscreen_conf)
STAR_ALIGN(star,gtf,BBDUK.out.bbduk_out)
TECOUNT(STAR_ALIGN.out.aligned,rmsk)
MULTIQC()
}
