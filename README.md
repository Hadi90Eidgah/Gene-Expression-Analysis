# Gene-Expr. Analysis
Gene Expr. by  Nextflow automation program.

The basic aim of the pipeline is to align (paired/single)_end reads to GENCODE - Human Release v.41 and further downstream analysis (i.e quantification of genes, DESeq analysis, PCA, HCL, etc ...)
Additionaly, using this pipeline one can quantify the Transposable Elements expressed in samples using the module that will be described here after. 

The pipeline includes: reads quality control, preprocessing (trimming and removing rRNA) , alignment and quantification.

## Nextflow Installation
---
Nextflow can be installed in any Conda Environment with `conda install -c bioconda nextflow=22.08.`.
Alternatively,`curl https://get.nextflow.io | bash`. In this case, run Nextflow as `./nextflow run`.

## Getting Started:
---
To run Nextflow, samples and their location must be specified in a csv file. 

The **input.csv** must be generated, comma separated, in the following way, having as header:

| name | fastq1 | fastq2 | strandedness|
| ---- | ------ | ------ | ------------|
| sample01 | /path/to/S01_R1.fastq |/path/to/S01_R2.fastq|forward / reverse / unstranded|
| sample02 | /path/to/S02_R1.fastq |/path/to/S02_R2.fastq|forward / reverse / unstranded|
| sample03 | /path/to/S03_R1.fastq |/path/to/S03_R2.fastq|forward / reverse / unstranded|
| sample ... | ... |(*if single-end, leave this field blank*)|forward / reverse / unstranded|

An example csv file is provided and can be found [here](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/input.csv).

## Which and Where:

| Directory    | file  | function  |
| ------------- |-------------| -----|
| ./assets      | [human_ribosomal.fa](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/assets/human_ribosomal.fa) | Common ribosomal 31-mers for BBDuk |
| ./assets      | [multiqc_config.yaml](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/assets/multiqc_config.yaml)    |MultiQC configuration file|
| ./conf | [base.config](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/conf/base.config)     |    Configuration file to execute the pipeline with HPC Slurm:Workload Manager  |
| ./conf | [fastq_screen.conf](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/conf/fastq_screen.config)| Fastqscreen configuration file
| ./modules | all the modules.nf | Modules to run the pipeline, the workflow is described below |
|./ | [main.nf](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/main.nf) | Main nextflow script
| ./ | [nextflow.config](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/nextflow.config) | Nextflow configuration file containing all the parameters and profile needed to run the pipeline



## Workflow:

1. **Reads concatenation** ([CONCAT](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/modules/concat_reads.nf)) Default = Run, skipped automatically if not needed


2. **FASTQ data pre-processing** ([FASTP](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/modules/fastp.nf)) quality control, trimming of adapters, filtering by quality, and read pruning. Default = Run


3. **Decontamination Using Kmers** ([BBDuk](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/modules/bbduk.nf)) Search for contaminant sequences, part of the BBTools package. Default = Run

4. **Overview of quality control metrics** ([FASTQC](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/modules/fastqc.nf)). Default = Run


5. **Detection of library contamination** ([FASTQSCREEN](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/modules/fastqscreen.nf)). Default = Run


6. **STAR indexing** (STAR_INDEX) Default = Skip 
STAR Index already provided. To create a custom STAR Index: 
provide genome (fasta) and annotation (gtf) in ./main.nf, and --star_idxist false.


7. **STAR alignment** ([STAR_ALIGN](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/modules/star_align.nf)) Default = Run 
Edit star_align.nf to define custom parameters.


8. **Quantification of Transposable Elements** ([TECOUNT](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/modules/tecount.nf))
Script to count reads mapping on Transposable Elements subfamilies, families and classes. Requires Python 3, samtools and bedtools.
Default = RUN


## How to Run the Pipeline:

Activate your nextflow conda environment with `conda activate nameCondaEnv`, then:

```
nextflow -C nextflow.config run main.nf \
         --input /path/to/input.csv \
         -w /path/to/work_dir \
         --outdir /path/to/your/results \
         -profile singularity \
         -resume -bg 
```

**Note:**
The Pipeline assumes by default a **Paired-End** library. To work with Single-End files: `--single_end true`.

## List of Params:

Parameter | Default Value | Alternative Value | function
--- | --- | --- | --- 
-C | when defined, any other config file will be overwritten | can be a file in the root directory e.g. [nextflow.config](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/nextflow.config) | defines the path of the main nextflow.config file
--input | must be defined  | can be defined inside [main.nf](https://github.com/Hadi90Eidgah/Gene-Expression-Analysis/blob/main/main.nf) (line 29 of the script) | defines the path of the input.csv samplesheet
-w | must be defined | nextflow defines it in root directory of the pipeline | defines the path of the Nextflow work directory
--outdir | ./results | - | defines the path where results will be saved separately from work directory
-bg | optional, but recommended | - | parameter to run Nextflow in background, prevents a broken pipeline in case of disconnection
-resume | - | - | allows for the continuation of a workflow execution

**Important:**  disabling certain processes could cause fatal errors (downstream steps may require previously generated files). 
For instance, STAR is required to perform most of the subsequent processes.
