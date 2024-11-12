#!/usr/bin/env bash
set -euo pipefail

# Assume kraken2 is installed

# Build db


# Has to be a fasta
gzip --decompress --keep resources/reference/mags_sub_kraken.fa.gz


kraken2-build \
    --no-masking \
    --add-to-library resources/reference/mags_sub_kraken.fa \
    --db kraken2_mock \
    --threads 4

rm -f  resources/reference/mags_sub_kraken.fa

kraken2-build \
    --download-taxonomy \
    --db kraken2_mock

kraken2-build \
    --build \
    --db kraken2_mock


# Run this with your sequence length
bracken-build \
    -d kraken2_mock \
    -t 8 \
    -k 35 \
    -l 100 \
    -y kraken2


kraken2-build \
    --clean \
    --db kraken2_mock

# Test

kraken2 \
    --db kraken2_mock \
    --threads 4 \
    --report kraken2_mock.report \
    --output kraken2_mock.out \
    --gzip-compressed \
    resources/reference/mags_sub_kraken.fa.gz


# Run

kraken2 \
    --db kraken2_mock \
    --threads 8 \
    --report sample1.report \
    --output >(gzip -9 > sample1.out.gz) \
    --gzip-compressed \
    --paired \
    resources/reads/sample1_1.fq.gz \
    resources/reads/sample1_2.fq.gz


bracken \
    -d kraken2_mock \
    -i sample1.report \
    -o sample1.bracken \
    -r 150
