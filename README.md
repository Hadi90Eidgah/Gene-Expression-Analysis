# Gene-Expr-Analysis
Gene Expr. by  Nextflow automation program.

The basic aim of the pipeline is to align (paired/single)_end reads to GENCODE - Human Release v.41 and further downstream analysis (i.e quantification of genes, DESeq analysis, PCA, HCL, etc ...)
Additionaly, using this pipeline one can quantify the Transposable Elements expressed in samples using the module that will be described here after. 

The pipeline includes: reads quality control, preprocessing (trimming and removing rRNA) , alignment and quantification.

### Nextflow Installation
---
Nextflow can be installed in any Conda Environment with `conda install -c bioconda nextflow=22.08.`.
Alternatively,`curl https://get.nextflow.io | bash`. In this case, run Nextflow as `./nextflow run`.

### Getting Started:
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
| ./conf
| ./modules
