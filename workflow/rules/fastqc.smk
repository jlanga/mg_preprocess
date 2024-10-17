rule fastqc__:
    """Run FastQC on a FASTQ file"""
    input:
        "{prefix}.fq.gz",
    output:
        html="{prefix}_fastqc.html",
        zip="{prefix}_fastqc.zip",
    log:
        "{prefix}_fastqc.log",
    params:
        extra="--quiet",
    wrapper:
        "v4.7.2/bio/fastqc"
