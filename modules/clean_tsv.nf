process CLEAN_TSV {

    input:
    tuple val(allele), path(tsv)

    output:
    path("${tsv.simpleName}.clean.tsv"), optional: true

    script:
    """
    cp "$tsv" "${tsv.simpleName}.clean.tsv"
    """
}
