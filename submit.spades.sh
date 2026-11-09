#!/bin/bash
# usage: bash submit_spades.sh samples.txt
for S in $(cat "$1"); do
  [[ -s ${S}.fa ]] && { echo "skip $S (done)"; continue; }
  ern jobs submit --name=spades_${S} --threads=8 --memory=68gb --hours=24 \
    --input=${S}_R1_filtered.fastq.gz \
    --input=${S}_R2_filtered.fastq.gz \
    --input=run_spades.sh \
    --module='spades/2.0_36268fe' \
    --command="bash run_spades.sh ${S}"
  sleep 2
done
