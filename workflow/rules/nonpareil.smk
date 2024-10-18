rule preprocess__nonpareil__run:
    """Run nonpareil over one sample

    NOTE: Nonpareil only ask for one of the pair-end reads
    NOTE: it has to be fastq. The process substitution trick does not work
    NOTE: in case that nonpareil fails for low coverage samples, it creates empty files
    """
    input:
        forward_=BOWTIE2 / "{sample_id}.{library_id}_1.fq.gz",
    output:
        npa=touch(NONPAREIL / "{sample_id}.{library_id}.npa"),
        npc=touch(NONPAREIL / "{sample_id}.{library_id}.npc"),
        npl=touch(NONPAREIL / "{sample_id}.{library_id}.npl"),
        npo=touch(NONPAREIL / "{sample_id}.{library_id}.npo"),
    log:
        NONPAREIL / "{sample_id}.{library_id}.log",
    conda:
        "../environments/nonpareil.yml"
    params:
        prefix=lambda w: NONPAREIL / f"{w.sample_id}.{w.library_id}",
    shell:
        """
        nonpareil \
            -s {input.forward_} \
            -T kmer \
            -b {params.prefix} \
            -f fastq \
            -t {threads} \
        2> {log} 1>&2 || true
        """


rule preprocess__nonpareil__curves:
    """Export nonpareil results to json for multiqc"""
    input:
        NONPAREIL / "{sample_id}.{library_id}.npo",
    output:
        NONPAREIL / "{sample_id}.{library_id}.json",
    log:
        NONPAREIL / "{sample_id}.{library_id}.json.log",
    conda:
        "../environments/nonpareil.yml"
    params:
        labels=lambda w: f"{w.sample_id}.{w.library_id}",
    shell:
        """
        Rscript --no-init-file $(which NonpareilCurves.R) \
            --labels {params.labels} \
            --json {output} \
            {input} \
        2> {log} 1>&2
        """


rule preprocess__nonpareil__all:
    """Run nonpareil over all samples and produce JSONs for multiqc"""
    input:
        [
            NONPAREIL / f"{sample_id}.{library_id}.json"
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
