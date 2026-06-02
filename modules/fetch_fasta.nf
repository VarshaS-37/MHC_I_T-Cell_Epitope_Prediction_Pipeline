process FETCH_FASTA {

    tag "$uniprot_id"

    input:
    val uniprot_id

    output:
    path "protein.fasta"

    script:
    """
    curl -s "https://rest.uniprot.org/uniprotkb/${uniprot_id}.fasta" \
        > protein.fasta

    echo "Downloaded FASTA for ${uniprot_id}"
    """
}
