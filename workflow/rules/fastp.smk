include: "fastp_functions.smk"


rule preprocess__fastp:
    """Run fastp on one PE library

    NOTE: don't use process substitution not because fastp cannot handle it,
    but because MultiQC reports will show /dev/fd/{63,64} as the sample names.
    """
    input:
        sample=[
            PRE_READS / "{sample_id}.{library_id}_1.fq.gz",
            PRE_READS / "{sample_id}.{library_id}_2.fq.gz",
        ],
    output:
        trimmed=[
            PRE_FASTP / "{sample_id}.{library_id}_1.fq.gz",
            PRE_FASTP / "{sample_id}.{library_id}_2.fq.gz",
        ],
        html=PRE_FASTP / "{sample_id}.{library_id}_fastp.html",
        json=PRE_FASTP / "{sample_id}.{library_id}_fastp.json",
    log:
        PRE_FASTP / "{sample_id}.{library_id}.log",
    group:
        "preprocess__{sample_id}.{library_id}"
    params:
        extra=params["preprocess"]["fastp"]["extra"],
        adapters=compose_adapters,
    wrapper:
        "v4.7.1/bio/fastp"


rule preprocess__fastp__all:
    """Run fastp over all libraries"""
    input:
        [
            PRE_FASTP / f"{sample_id}.{library_id}_{end}.fq.gz"
            for sample_id, library_id in SAMPLE_LIBRARY
            for end in [1, 2]
        ],
