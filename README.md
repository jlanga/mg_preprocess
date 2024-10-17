# Snakemake workflow: `mg_preprocess`

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.0.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/jlanga/mg_preprocess/workflows/Tests/badge.svg)](https://github.com/jlanga/mg_preprocess/actions)


A Snakemake workflow for preprocessing FASTQ reads for metagenomics.

This is an auxiliary pipeline for:
 - [mg_assembly](https://github.com/3d-omics/mg_assembly)
 - [mg_quant](https://github.com/3d-omics/mg_quant)

## Usage

0. Requirements
   1.  [`miniconda`](https://docs.conda.io/en/latest/miniconda.html) / [`mamba`](https://mamba.readthedocs.io)
   2.  [`snakemake`](snakemake.readthedocs.io/)

1. Clone the repository
Clone the repository, and set it as the working directory.

```
git clone --recursive https://github.com/3d-omics/mg_preprocess.git
cd mg_prepreocess
```

2. Run the pipeline with the test data (takes 5 minutes to download the required software)
```
snakemake \
    --use-conda \
    --conda-frontend mamba \
    --jobs 8
```

3. Edit the following files:
   1. `config/samples.tsv`: the control file with the sequencing libraries and their location.
      ```
      sample_id	library_id	forward_filename	reverse_filename	forward_adapter	reverse_adapter
      sample1	lib1	resources/reads/sample1_1.fq.gz	resources/reads/sample1_2.fq.gz	AGATCGGAAGAGCACACGTCTGAACTCCAGTCA	AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
      sample2	lib1	resources/reads/sample2_1.fq.gz	resources/reads/sample2_2.fq.gz	AGATCGGAAGAGCACACGTCTGAACTCCAGTCA	AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
      ```
   2. `config/features.yml`: the references and databases against which to screen the libraries.
      ```
      references:  # Reads will be mapped sequentially
         human: resources/reference/human_22_sub.fa.gz
         chicken: resources/reference/chicken_39_sub.fa.gz

      databases:
         kraken2:
            mock1: resources/databases/kraken2/kraken2_RefSeqV205_Complete_500GB
            # refseq500: resources/databases/kraken2/kraken2_RefSeqV205_Complete_500GB
         singlem: resources/databases/singlem/S3.2.1.GTDB_r214.metapackage_20231006.smpkg.zb
      ```

   3. `config/params.yml`: parameters for every program. The defaults are reasonable.


4. Run the pipeline and go for a walk:

```
snakemake \
    --use-conda \
    --profile profile/default \
    --jobs 100 \
    --cores 24 \
    --keep-going \
    `#--executor slurm`
```

## Rulegraph

![rulegraph](.rulegraph/rulegraph_simple.svg)

## Brief description

1. Trim reads and remove adaptors with `fastp`
2. Map to human, chicken / pig, mag catalogue:
   1. Map to the reference with `bowtie2`
   2. Extract the reads that have one of both ends unmapped with `samtools`
   3. Map those unmapped reads to the next reference
4. Generate reference-free statistics with `singlem` and `nonpareil`
5. Assign taxonomies to reads with `kraken2`
6. Generate a report with `multiqc`


## References

- [fastp](https://github.com/OpenGene/fastp)
- [bowtie2](https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml)
- [samtools](https://www.htslib.org/)
- [singlem](https://github.com/wwood/singlem)
- [nonpareil](http://enve-omics.ce.gatech.edu/nonpareil/)
- [fastqc](https://github.com/s-andrews/FastQC)
- [multiqc](https://multiqc.info/)
- [kraken2](https://github.com/DerrickWood/kraken2)
