def get_input_fastq_for_host_mapping(wildcards):
    """Get the input cram file for host mapping"""
    sample_id = wildcards.sample_id
    library_id = wildcards.library_id
    host = wildcards.host
    host_index = HOST_NAMES.index(host)
    print(host_index)
    if host_index == 0:
        return [
            FASTP / f"{sample_id}.{library_id}_1.fq.gz",
            FASTP / f"{sample_id}.{library_id}_2.fq.gz",
        ]
    previous_host = HOST_NAMES[host_index - 1]
    return [
        BOWTIE2 / f"{previous_host}" / f"{sample_id}.{library_id}_u1.fq.gz",
        BOWTIE2 / f"{previous_host}" / f"{sample_id}.{library_id}_u2.fq.gz",
    ]


def get_forward_fastq(wildcards):
    return get_input_fastq_for_host_mapping(wildcards)[0]

def get_reverse_fastq(wildcards):
    return get_input_fastq_for_host_mapping(wildcards)[1]

def compose_rg_id(wildcards):
    """Compose the read group ID for bowtie2"""
    return f"{wildcards.sample_id}_{wildcards.library_id}"

def compose_rg_extra(wildcards):
    """Compose the read group extra information for bowtie2"""
    return f"LB:truseq_{wildcards.library_id}\\tPL:Illumina\\tSM:{wildcards.sample_id}"



def get_final_fastq(wildcards):
    """Get the final fastq file for the host mapping"""
    sample_id = wildcards.sample_id
    library_id = wildcards.library_id
    if len(HOST_NAMES) == 0:
        return [
            FASTP / f"{sample_id}.{library_id}_1.fq.gz",
            FASTP / f"{sample_id}.{library_id}_2.fq.gz",
        ]
    last_host = HOST_NAMES[-1]
    return [
        BOWTIE2 / f"{last_host}" / f"{sample_id}.{library_id}_u1.fq.gz",
        BOWTIE2 / f"{last_host}" / f"{sample_id}.{library_id}_u2.fq.gz",
    ]

def get_final_fastq_forward(wildcards):
    return get_final_fastq(wildcards)[0]

def get_final_fastq_reverse(wildcards):
    return get_final_fastq(wildcards)[1]