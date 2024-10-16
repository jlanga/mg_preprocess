rule samtools__index_bam__:
    """Index a bam file"""
    input:
        "{prefix}.bam",
    output:
        "{prefix}.bam.bai",
    log:
        "{prefix}.bam.bai.log",
    wrapper:
        "v4.7.2/bio/samtools/faidx"


rule samtools__index_cram__:
    """Index a cram file"""
    input:
        "{prefix}.cram",
    output:
        "{prefix}.cram.crai",
    log:
        "{prefix}.cram.crai.log",
    wrapper:
        "v4.7.2/bio/samtools/faidx"


rule faidx_fasta:
    """Index a fasta file"""
    input:
        "{prefix}.fasta",
    output:
        "{prefix}.fasta.fai",
    log:
        "{prefix}.fa.fai.log",
    wrapper:
        "v4.7.2/bio/samtools/faidx"

rule faidx_fa:
    """Index a fasta file"""
    input:
        "{prefix}.fa",
    output:
        "{prefix}.fa.fai",
    log:
        "{prefix}.fa.fai.log",
    wrapper:
        "v4.7.2/bio/samtools/faidx"


rule faidx_fasta_gz:
    """Index a fasta file"""
    input:
        "{prefix}.fasta.gz",
    output:
        "{prefix}.fasta.gz.fai",
    log:
        "{prefix}.fa.fai.log",
    wrapper:
        "v4.7.2/bio/samtools/faidx"


rule faidx_fagz:
    """Index a gzipped fasta file"""
    input:
        "{prefix}.fa.gz",
    output:
        fai="{prefix}.fa.gz.fai",
        gzi="{prefix}.fa.gz.gzi",
    log:
        "{prefix}.fa.gz.log",
    wrapper:
        "v4.7.2/bio/samtools/faidx"


rule idxstats_cram:
    """Compute idxstats for a cram"""
    input:
        cram="{prefix}.cram",
        crai="{prefix}.cram.crai",
    output:
        tsv="{prefix}.idxstats.tsv",
    log:
        "{prefix}.idxstats.log",
    wrapper:
        "v4.7.2/bio/samtools/idxstats"


rule flagstats_cram:
    """Compute flagstats for a cram"""
    input:
        cram="{prefix}.cram",
        crai="{prefix}.cram.crai",
    output:
        txt="{prefix}.flagstats.txt",
    log:
        "{prefix}.flagstats.log",
    wrapper:
        "v4.7.2/bio/samtools/idxstats"