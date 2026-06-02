process FILTER_EPITOPES {

    publishDir "results", mode: 'copy'

    input:
    path tsv

    output:
    path "final_epitopes.tsv"

    script:
    """
    if [ ! -s $tsv ]; then
        echo "No data" > final_epitopes.tsv
        exit 0
    fi

    # keep header
    head -n 1 $tsv > final_epitopes.tsv

    # filter ONLY by score
    awk -F '\\t' '
    NR > 1 {
        peptide = \$6
        score = \$9 + 0

        if (score >= 0.5) {
            print \$0
        }
    }' $tsv >> final_epitopes.tsv
    """
}
