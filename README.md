# nmkize

mkdir -p 16S_extraction

bash extract_16S.sh

# Spades
ls *_R1_filtered.fastq.gz | sed 's/_R1_filtered.fastq.gz//' > samples_all.txt
wc -l samples_all.txt
bash submit_spades.sh samples_all.txt



