include: "bowtie2_functions.smk"

rule bowtie2_build__:
    """Build bowtie2 index for a reference

    NOTE: Let the script decide to use a small or a large index based on the size of
    the reference genome.
    """
    input:
        reference=HOSTS / "{host}.fa.gz",
    output:
        multiext(
            str(BOWTIE2 / "build" / "{host}"),
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        ),
    log:
        BOWTIE2 / "build" / "{host}.log",
    conda:
        "../environments/bowtie2.yml"
    params:
        prefix=lambda w: str(BOWTIE2 / f"{w.host}"),
    cache: "omit-software"
    shell:
        """
        bowtie2-build \
            --threads {threads} \
            {input.reference} \
            {params.prefix} \
        2> {log} 1>&2
        """


rule bowtie2__build:
    """Build bowtie2 index for all host genomes"""
    input:
        [
            BOWTIE2 / "build" / f"{host}.{end}"
            for end in ["1.bt2", "2.bt2", "3.bt2", "4.bt2", "rev.1.bt2", "rev.2.bt2"]
            for host in HOST_NAMES
        ],


rule bowtie2__map__:
    """Map one library to reference genome using bowtie2

    Output SAM file is piped to samtools sort to generate a CRAM file.
    """
    input:
        forward_=get_forward_fastq,
        reverse_=get_reverse_fastq,
        mock=multiext(
            str(BOWTIE2 / "build" / "{host}"),
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        ),
        reference=HOSTS / "{host}.fa.gz",
        fai=HOSTS / "{host}.fa.gz.fai",
        gzi=HOSTS / "{host}.fa.gz.gzi",
    output:
        bam=BOWTIE2 / "{host}" / "{sample_id}.{library_id}.bam",
    log:
        BOWTIE2 / "{host}" / "{sample_id}.{library_id}.log",
    params:
        index=lambda w: BOWTIE2 / "build" / f"{w.host}",
        samtools_extra=params["bowtie2"]["samtools_extra"],
        bowtie2_extra=params["bowtie2"]["bowtie2_extra"],
        rg_id=compose_rg_id,
        rg_extra=compose_rg_extra,
    conda:
        "../environments/bowtie2.yml"
    shell:
        """
        ( bowtie2 \
            -x {params.index} \
            -1 {input.forward_} \
            -2 {input.reverse_} \
            {params.bowtie2_extra} \
            --rg '{params.rg_extra}' \
            --rg-id '{params.rg_id}' \
            --threads {threads} \
        | samtools sort \
            {params.samtools_extra} \
            --reference {input.reference} \
            --threads {threads} \
            -T {output.bam} \
            -o {output.bam} \
        ) 2> {log} 1>&2
        """


rule bowtie2__map:
    input:
        [
            BOWTIE2 / host / f"{sample_id}.{library_id}.bam"
            for host in HOST_NAMES
            for sample_id, library_id in SAMPLE_LIBRARY
        ],


rule bowtie2__unaligned__:
    """Convert BAM to FASTQ using samtools and using the correct reference

    NOTE: bowtie2 does not like CRAM files, and although can use a BAM file as an input,
    bowtie2 fails to receive a piped SAM input. Therefore, we need to convert the CRAM file to a physical FASTQ file.
    """
    input:
        bam = BOWTIE2 / "{host}" / "{sample_id}.{library_id}.bam",
    output:
        forward_=temp(BOWTIE2 / "{host}" / "{sample_id}.{library_id}_u1.fq.gz"),
        reverse_=temp(BOWTIE2 / "{host}" / "{sample_id}.{library_id}_u2.fq.gz"),
    log:
        BOWTIE2 / "{host}" / "{sample_id}.{library_id}.unaligned.log",
    conda:
        "../environments/bowtie2.yml"
    shell:
        """
        rm \
            --recursive \
            --force \
            {output.forward_}.collate

        ( samtools view \
            -f 12 \
            -u \
            --threads {threads} \
            {input} \
        | samtools collate \
            -O \
            -u \
            -f \
            -T {output.forward_}.collate \
            --threads {threads} \
            - \
        | samtools fastq \
            -1 {output.forward_} \
            -2 {output.reverse_} \
            -0 /dev/null \
            -s /dev/null \
            --threads {threads} \
            -c 9 \
            /dev/stdin \
        ) 2> {log} 1>&2
        """


rule bowtie2__unaligned:
    input:
        [
            BOWTIE2 / host / f"{sample_id}.{library_id}_u{end}.fq.gz"
            for host in HOST_NAMES
            for sample_id, library_id in SAMPLE_LIBRARY
            for end in [1, 2]
        ],


rule bowtie2__clean__:
    input:
        forward_=get_final_fastq_forward,
        reverse_=get_final_fastq_reverse,
    output:
        forward_=BOWTIE2 / "{sample_id}.{library_id}_1.fq.gz",
        reverse_=BOWTIE2 / "{sample_id}.{library_id}_2.fq.gz",
    log:
        BOWTIE2 / "{sample_id}.{library_id}.log",
    conda:
        "../environments/bowtie2.yml"
    shell:
        """
        ln --force {input.forward_} {output.forward_} 2>  {log}
        ln --force {input.reverse_} {output.reverse_} 2>> {log}
        """


rule bowtie2__clean:
    input:
        [
            BOWTIE2 / f"{sample_id}.{library_id}_{end}.fq.gz"
            for sample_id, library_id in SAMPLE_LIBRARY
            for end in [1, 2]
        ],


rule bowtie2:
    input:
        rules.bowtie2__build.input,
        rules.bowtie2__map.input,
        rules.bowtie2__unaligned.input,
        rules.bowtie2__clean.input,
