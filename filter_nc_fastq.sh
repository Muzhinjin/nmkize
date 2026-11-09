#!/usr/bin/env bash
set -euo pipefail

mkdir -p filtered logs

# Process standard R1/R2 pairs
for r1 in *_R1.fastq; do
    [[ -f "$r1" ]] || continue
    prefix="${r1%_R1.fastq}"
    r2="${prefix}_R2.fastq"

    if [[ ! -f "$r2" ]]; then
        echo "WARNING: Missing R2 for $r1" >&2
        continue
    fi

    fastp \
        -i "$r1" -I "$r2" \
        -o "filtered/${prefix}_R1_filtered.fastq.gz" \
        -O "filtered/${prefix}_R2_filtered.fastq.gz" \
        --detect_adapter_for_pe \
        --qualified_quality_phred 20 \
        --unqualified_percent_limit 40 \
        --length_required 50 \
        --thread 4 \
        --html "logs/${prefix}_fastp.html" \
        --json "logs/${prefix}_fastp.json"
done

echo "Paired-end filtering completed."
