#!/bin/bash

set -euo pipefail

mkdir -p 16S_extraction

GENOMES=(
    "NM-MR1.fasta"
    "NM-WG1.fasta"
    "NM-unlabelled.fasta"
)

for GENOME in "${GENOMES[@]}"; do

    NAME="${GENOME%.fasta}"

    echo "Processing ${GENOME}..."

    # Identify and extract all bacterial rRNA genes
    barrnap \
        --kingdom bac \
        --threads 4 \
        --outseq "16S_extraction/${NAME}_all_rRNA.fasta" \
        "$GENOME" > "16S_extraction/${NAME}_rRNA.gff"

    # Retain only 16S rRNA sequences
    awk '
    /^>/ {
        keep = ($0 ~ /16S/i)
    }
    keep {
        print
    }
    ' "16S_extraction/${NAME}_all_rRNA.fasta" \
      > "16S_extraction/${NAME}_16S.fasta"

    echo "Finished ${GENOME}"

done

# Combine all extracted 16S sequences
cat 16S_extraction/*_16S.fasta \
    > 16S_extraction/all_16S_sequences.fasta

echo "16S extraction completed!"
