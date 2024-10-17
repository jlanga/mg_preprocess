rule hosts__:
    """Extract the fasta.gz on config.yaml into genome.fa,gz with bgzip"""
    input:
        fa_gz=lambda wildcards: features["hosts"][wildcards.host],
    output:
        fa_gz=HOSTS / "{host}.fa.gz",
    log:
        HOSTS / "{host}.log",
    conda:
        "../environments/hosts.yml"
    cache: "omit-software"
    shell:
        """
        ( gzip \
            --decompress \
            --stdout {input.fa_gz} \
        | bgzip \
            --compress-level 9 \
            --threads {threads} \
            --stdout \
            /dev/stdin \
        > {output.fa_gz} \
        ) 2> {log}
        """


rule hosts:
    """Recompress all host genomes"""
    input:
        [HOSTS / f"{host}.fa.gz" for host in HOST_NAMES],