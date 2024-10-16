def get_input(wildcards, forward_or_reverse):
    """Get the initial file"""
    assert forward_or_reverse in ["forward_filename", "reverse_filename"]
    return samples.loc[
        (samples["sample_id"] == wildcards.sample_id)
        & (samples["library_id"] == wildcards.library_id)
    ][forward_or_reverse].values[0]


def get_forward(wildcards):
    """Get the forward read for a given sample and library"""
    return get_input(wildcards, "forward_filename")


def get_reverse(wildcards):
    """Get the reverse read for a given sample and library"""
    return get_input(wildcards, "reverse_filename")
