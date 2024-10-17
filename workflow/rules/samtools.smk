rule samtools__faidx_fagz__:
    """Index a gzipped fa file"""
    input:
        "{prefix}.fa.gz",
    output:
        fai="{prefix}.fa.gz.fai",
        gzi="{prefix}.fa.gz.gzi",
    log:
        "{prefix}.fa.gz.log",
    wrapper:
        "v4.7.2/bio/samtools/faidx"


rule samtools__index_bam__:
    """Index a bam file"""
    input:
        "{prefix}.bam",
    output:
        "{prefix}.bam.bai",
    log:
        "{prefix}.bam.bai.log",
    wrapper:
        "v4.7.2/bio/samtools/index"


rule samtools__idxstats__:
    """Compute idxstats for a cram"""
    input:
        bam="{prefix}.bam",
        bai="{prefix}.bam.bai",
    output:
        tsv="{prefix}.idxstats.tsv",
    log:
        "{prefix}.idxstats.log",
    wrapper:
        "v4.7.2/bio/samtools/idxstats"


rule samtools__flagstats__:
    """Compute flagstats for a cram"""
    input:
        bam="{prefix}.bam",
        bai="{prefix}.bam.bai",
    output:
        txt="{prefix}.flagstats.txt",
    log:
        "{prefix}.flagstats.log",
    wrapper:
        "v4.7.2/bio/samtools/idxstats"

rule samtools__stats__:
    input:
        bam="{prefix}.bam",
    output:
        "{prefix}.stats.tsv",
    log:
        "{prefix}.stats.log",
    wrapper:
        "v4.7.2/bio/samtools/stats"