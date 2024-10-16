include: "fastp_functions.smk"

rule fastp__trim__:
    """Run fastp on one PE library

    NOTE: don't use process substitution not because fastp cannot handle it,
    but because MultiQC reports will show /dev/fd/{63,64} as the sample names.
    """
    input:
        sample=[
            READS / "{sample_id}.{library_id}_1.fq.gz",
            READS / "{sample_id}.{library_id}_2.fq.gz",
        ]
    output:
        trimmed=[
            FASTP / "{sample_id}.{library_id}_1.fq.gz",
            FASTP / "{sample_id}.{library_id}_2.fq.gz",
        ],
        html = FASTP / "{sample_id}.{library_id}.html",
        json = FASTP / "{sample_id}.{library_id}.json",
    log:
        FASTP / "{sample_id}.{library_id}.log",
    params:
        extra=params["fastp"]["extra"],
        adapters=compose_adapters,
    wrapper:
        "v4.7.1/bio/fastp"


rule fastp:
    """Run fastp over all libraries"""
    input:
        [
            FASTP / f"{sample_id}.{library_id}_{end}.fq.gz"
            for sample_id, library_id in SAMPLE_LIBRARY
            for end in [1, 2]
        ],
