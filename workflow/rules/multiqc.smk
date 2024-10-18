rule multiqc__:
    input:
        reads=[
            READS / f"{sample_id}.{library_id}_{end}_fastqc.zip"
            for sample_id, library_id in SAMPLE_LIBRARY
            for end in [1, 2]
        ],
        fastp=[
            FASTP / f"{sample_id}.{library_id}_fastp.html"
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
        bowtie2=[
            BOWTIE2 / f"{host}.{sample_id}.{library_id}.{report}"
            for host in HOST_NAMES
            for report in BAM_REPORTS
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
        clean=[
            BOWTIE2 / f"{sample_id}.{library_id}_{end}_fastqc.zip"
            for sample_id, library_id in SAMPLE_LIBRARY
            for end in ["1", "2"]
        ],
        nonpareil=[
            NONPAREIL / f"{sample_id}.{library_id}.json"
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
        kraken2=[
            KRAKEN2 / kraken2_db / f"{sample_id}.{library_id}.report"
            for sample_id, library_id in SAMPLE_LIBRARY
            for kraken2_db in KRAKEN2_DBS
        ],
    output:
        html=RESULTS / "preprocess.html",
        folder=directory(RESULTS / "preprocess_data"),
    log:
        RESULTS / "preprocess.log",
    conda:
        "../environments/multiqc.yml"
    params:
        outdir=RESULTS,
    shell:
        """
        multiqc \
            --title preprocess \
            --force \
            --filename preprocess \
            --outdir {params.outdir} \
            --dirs \
            --dirs-depth 1 \
            --fullnames \
            {input} \
        2> {log} 1>&2
        """


rule multiqc:
    input:
        rules.multiqc__.output,
