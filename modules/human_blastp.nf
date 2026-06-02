process HUMAN_BLASTP {

    publishDir "results", mode: 'copy'

    input:
    path fasta

    output:
    path "blast_results.tsv"

    script:
    """
    blastp \
	-task blastp-short \
	-query epitopes.fasta \
	-db ${params.human_db} \
	-out blast_results.tsv \
	-evalue 100000 \
	-max_target_seqs 1 \
	-outfmt "6 qseqid sseqid pident length evalue bitscore"
    """
}
