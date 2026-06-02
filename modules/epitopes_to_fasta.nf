process EPITOPES_TO_FASTA {

    publishDir "results", mode: 'copy'

    input:
    path epitopes_tsv

    output:
    path "epitopes.fasta"

    script:
    """
    awk 'BEGIN{FS=OFS="\\t"}
    NR==1{
        for(i=1;i<=NF;i++){
            if(\$i=="peptide") col=i
        }
    }
    NR>1{
        print ">pep"NR-1
        print \$col
    }' $epitopes_tsv > epitopes.fasta
    """
}
