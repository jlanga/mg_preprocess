def compose_adapters(wildcards):
    """Compose the forward and reverse adapter line for fastp"""
    forward = get_forward_adapter(wildcards)
    reverse = get_reverse_adapter(wildcards)
    return f"--adapter_sequence {forward} --adapter_sequence_r2 {reverse}"
