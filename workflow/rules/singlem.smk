rule preprocess__singlem__pipe:
    """Run singlem over one sample

    NOTE: SingleM asks in the documentation for the raw reads. Here we are
    passing it the non-host and trimmed ones.
    """
    input:
        forward_=PRE_FASTP / "{sample_id}.{library_id}_1.fq.gz",
        reverse_=PRE_FASTP / "{sample_id}.{library_id}_2.fq.gz",
        data=features["databases"]["singlem"],
    output:
        archive_otu_table=PRE_SINGLEM / "pipe" / "{sample_id}.{library_id}.archive.json",
        otu_table=PRE_SINGLEM / "pipe" / "{sample_id}.{library_id}.otu_table.tsv",
        condense=PRE_SINGLEM / "pipe" / "{sample_id}.{library_id}.condense.tsv",
    log:
        PRE_SINGLEM / "pipe" / "{sample_id}.{library_id}.log",
    conda:
        "../environments/singlem.yml"
    shell:
        """
        singlem pipe \
            --forward {input.forward_} \
            --reverse {input.reverse_} \
            --otu-table {output.otu_table} \
            --archive-otu-table {output.archive_otu_table} \
            --taxonomic-profile {output.condense} \
            --metapackage {input.data} \
            --assignment-threads {threads} \
        2> {log} 1>&2
        """


rule preprocess__singlem__condense:
    """Aggregate all the singlem results into a single table"""
    input:
        archive_otu_tables=[
            PRE_SINGLEM / "pipe" / f"{sample_id}.{library_id}.archive.json"
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
        data=features["databases"]["singlem"],
    output:
        condense=PRE_SINGLEM / "singlem.tsv",
    log:
        PRE_SINGLEM / "singlem.log",
    conda:
        "__environment__.yml"
    params:
        input_dir=PRE_SINGLEM,
    shell:
        """
        singlem condense \
            --input-archive-otu-tables {input.archive_otu_tables} \
            --taxonomic-profile {output.condense} \
            --metapackage {input.data} \
        2> {log} 1>&2
        """


rule preprocess__singlem__microbial_fraction:
    """Run singlem microbial_fraction over one sample"""
    input:
        forward_=PRE_FASTP / "{sample_id}.{library_id}_1.fq.gz",
        reverse_=PRE_FASTP / "{sample_id}.{library_id}_2.fq.gz",
        data=features["databases"]["singlem"],
        condense=PRE_SINGLEM / "pipe" / "{sample_id}.{library_id}.condense.tsv",
    output:
        microbial_fraction=PRE_SINGLEM
        / "microbial_fraction"
        / "{sample_id}.{library_id}.tsv",
    log:
        PRE_SINGLEM / "microbial_fraction" / "{sample_id}.{library_id}.log",
    conda:
        "../environments/singlem.yml"
    shell:
        """
        singlem microbial_fraction \
            --forward {input.forward_} \
            --reverse {input.reverse_} \
            --input-profile {input.condense} \
            --output-tsv {output.microbial_fraction} \
            --metapackage {input.data} \
        2> {log} 1>&2
        """


rule preprocess__singlem__microbial_fraction__aggregate:
    """Aggregate all the microbial_fraction files into one tsv"""
    input:
        tsvs=[
            PRE_SINGLEM / "microbial_fraction" / f"{sample_id}.{library_id}.tsv"
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
    output:
        tsv=PRE_SINGLEM / "microbial_fraction.tsv",
    log:
        PRE_SINGLEM / "microbial_fraction.log",
    conda:
        "../environments/singlem.yml"
    shell:
        """
        ( csvstack \
            --tabs \
            {input.tsvs} \
        | csvformat \
            --out-tabs \
        > {output.tsv} \
        ) 2> {log}
        """


rule preprocess__singlem__all:
    input:
        rules.preprocess__singlem__microbial_fraction__aggregate.output,
