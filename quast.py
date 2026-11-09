#!/bin/bash

shopt -s nullglob

for fasta in *.fasta; do
    name="${fasta%.fasta}"

    ern jobs submit \
        --name="QUAST_${name}" \
        --threads=32 \
        --memory=128gb \
        --hours=24 \
        --input="$fasta" \
        --module="quast/2.0_e1c0f74" \
        --command="quast.py '$fasta' -o '${name}_quast' -t 32"
done
