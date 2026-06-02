process IEDB_MHC {

    publishDir "results", mode: 'copy'

    input:
    path fasta
    val allele

    output:
    tuple val(allele), path("*.tsv")

    script:
    def safe_allele = allele.replaceAll(/[^A-Za-z0-9]/, "_")

    """
    # Extract sequence
    seq=\$(grep -v ">" $fasta | tr -d '\\n')

    # MHC-I prediction only
    curl -s -X POST \
        --data-urlencode "method=netmhcpan_el" \
        --data-urlencode "sequence_text=\$seq" \
        --data-urlencode "allele=$allele" \
        --data-urlencode "length=9" \
        https://tools-cluster-interface.iedb.org/tools_api/mhci/ \
        > ${safe_allele}.tsv
    """
}
