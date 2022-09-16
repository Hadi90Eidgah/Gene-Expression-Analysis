// Enable DSL2
nextflow.enable.dsl = 2
/*
  ----------------------------------------------------------------------------
                       Main Nextflow script:
*/

include {FASTP} from './modules/fastp'
include {BBDUK} from './modules/bbduk'
include {FASTQC} from './modules/fastqc'
include {FASTQSCREEN} from './modules/fastqscreen'
include {STAR_ALIGN} from './modules/star_align'
include {TECOUNT} from './modules/tecount'
workflow{
    reads = Channel
        .fromPath('/mnt/projects/labs/GEBI/tes_hadi/pipeline/tecount_immune.csv')  //CSV header: name,fastq[,fastq2],strandness
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

rRNAs= '/mnt/projects/labs/GEBI/tes_hadi/pipeline/assets/human_ribosomal.fa'
fastqscreen_conf = '/mnt/projects/labs/GEBI/tes_hadi/pipeline/conf/fastq_screen.config'
gtf='/mnt/projects/labs/GEBI/tes_hadi/refs/gencode.v41.pri.ucsc.names.gtf'
star = '/mnt/genomes/GRCh38/star/STAR276a'
rmsk= '/mnt/genomes/GRCh38/repeatmasker/rmsk_hg38_open-4.0.3-20130422.bed.gz'

FASTP(reads)
BBDUK(FASTP.out.trimmed,rRNAs)
FASTQC(BBDUK.out.bbduk_out)
FASTQSCREEN(BBDUK.out.bbduk_out,fastqscreen_conf)
STAR_ALIGN(star,gtf,BBDUK.out.bbduk_out)
TECOUNT(STAR_ALIGN.out.aligned,rmsk)
}
