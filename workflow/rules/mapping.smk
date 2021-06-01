rule trim_reads_pe:
    input:
        unpack(get_fastq),
    output:
        r1=temp(os.path.join(config["working_dir"], "fastqs/trimmed/{sample}-{unit}.1.fastq.gz")),
        r2=temp(os.path.join(config["working_dir"], "fastqs/trimmed/{sample}-{unit}.2.fastq.gz")),
        r1_unpaired=temp(os.path.join(config["working_dir"], "fastqs/trimmed/{sample}-{unit}.1.unpaired.fastq.gz")),
        r2_unpaired=temp(os.path.join(config["working_dir"], "fastqs/trimmed/{sample}-{unit}.2.unpaired.fastq.gz")),
        trimlog=os.path.join(config["working_dir"], "fastqs/trimmed/{sample}-{unit}.trimlog.txt"),
    params:
        **config["params"]["trimmomatic"]["pe"],
        extra=lambda w, output: "-trimlog {}".format(output.trimlog),
    wrapper:
        "0.74.0/bio/trimmomatic/pe"

rule map_reads:
    input:
        reads = get_trimmed_reads,
        reference = config["ref_path"]
    output:
        os.path.join(config["working_dir"], "sams/mapped/{sample}-{unit}.sam")
    params:
        extra="-ax sr"
    threads: 4
    wrapper:
        "0.74.0/bio/minimap2/aligner"