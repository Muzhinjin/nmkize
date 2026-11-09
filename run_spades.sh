#!/bin/bash
set -euo pipefail

S="$1"
SPADES="$HOME/ern/environments/deploy/bin/spades/2.0_36268fe/v3.13/spades.py"
OUT="spades_${S}"

# Check input files
[[ -s "${S}_R1_filtered.fastq.gz" ]] || {
    echo "ERROR: Missing R1 reads for ${S}" >&2
    exit 1
}
[[ -s "${S}_R2_filtered.fastq.gz" ]] || {
    echo "ERROR: Missing R2 reads for ${S}" >&2
    exit 1
}

# Run SPAdes
"$SPADES" \
    --isolate \
    -t 8 \
    -m 64 \
    -1 "${S}_R1_filtered.fastq.gz" \
    -2 "${S}_R2_filtered.fastq.gz" \
    -o "$OUT"

# Verify assembly output
[[ -s "$OUT/contigs.fasta" ]] || {
    echo "ERROR: contigs.fasta not found for ${S}" >&2
    exit 1
}

# Keep contigs >=500 bp and prefix headers with isolate ID
awk -v s="$S" '
    /^>/ {
        if (seq != "" && length(seq) >= 500)
            print hdr "\n" seq
        hdr = ">" s "_" substr($0, 2)
        seq = ""
        next
    }
    {
        seq = seq $0
    }
    END {
        if (length(seq) >= 500)
            print hdr "\n" seq
    }
' "$OUT/contigs.fasta" > "${S}.fa"

# Save log
cp "$OUT/spades.log" "${S}.spades.log"

# Remove intermediate files after successful filtering
rm -rf "$OUT/corrected" "$OUT/tmp" "$OUT"/K* "$OUT/misc"

echo "Finished ${S}: $(grep -c '^>' "${S}.fa") contigs >=500 bp"
