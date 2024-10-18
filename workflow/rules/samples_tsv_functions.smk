def get_input_filename(wildcards, forward_or_reverse):
    """Get the initial file"""
    assert forward_or_reverse in ["forward_filename", "reverse_filename"]
    return samples.loc[
        (samples["sample_id"] == wildcards.sample_id)
        & (samples["library_id"] == wildcards.library_id)
    ][forward_or_reverse].values[0]


def get_forward_filename(wildcards):
    """Get the forward read for a given sample and library"""
    return get_input_filename(wildcards, "forward_filename")


def get_reverse_filename(wildcards):
    """Get the reverse read for a given sample and library"""
    return get_input_filename(wildcards, "reverse_filename")


def get_adapter(wildcards, forward_or_reverse):
    """Get forward or reverse adapter"""
    assert forward_or_reverse in ["forward_adapter", "reverse_adapter"]
    return samples[
        (samples["sample_id"] == wildcards.sample_id)
        & (samples["library_id"] == wildcards.library_id)
    ][forward_or_reverse].tolist()[0]


def get_forward_adapter(wildcards):
    """Get forward adapter for a sample and library."""
    return get_adapter(wildcards, "forward_adapter")


def get_reverse_adapter(wildcards):
    """Get reverse adapter for a sample and library."""
    return get_adapter(wildcards, "reverse_adapter")


def compose_rg_id(wildcards):
    """Compose the read group ID for bowtie2"""
    return f"{wildcards.sample_id}_{wildcards.library_id}"


def compose_rg_extra(wildcards):
    """Compose the read group extra information for bowtie2"""
    return f"LB:truseq_{wildcards.library_id}\\tPL:Illumina\\tSM:{wildcards.sample_id}"
