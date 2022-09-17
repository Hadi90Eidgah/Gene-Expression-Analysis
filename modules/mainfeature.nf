// Enable DSL2
nextflow.enable.dsl = 2
/*
  ----------------------------------------------------------------------------
                       Main Nextflow script:
*/

include {FEATURECOUNTS} from './modules/featurecounts'

workflow{
    reads = Channel
        .fromPath('/mnt/projects/labs/GEBI/tes_hadi/pipeline/featureCounts_dataset.csv')  //CSV header: name,bam,str>
        .splitCsv(header: true)
        .tap { ch_samplesheet } //
        .map { sample ->
             [ sample.name, file(sample.bam) ]
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

gtf='/mnt/projects/labs/GEBI/tes_hadi/refs/gencode.v41.pri.ucsc.names.gtf'

FEATURECOUNTS(gtf,bam)
}

