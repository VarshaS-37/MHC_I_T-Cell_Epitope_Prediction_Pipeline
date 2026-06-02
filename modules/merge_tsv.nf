process MERGE_TSV {

    publishDir "results", mode: 'copy'

    input:
    path tsv_files

    output:
    path "final_iedb.tsv"

    shell:
    '''
    rm -f final_iedb.tsv

    first=1

    for f in !{tsv_files}; do

        [ -s "$f" ] || continue

        if [ $first -eq 1 ]; then
            cat "$f" > final_iedb.tsv
            first=0
        else
            tail -n +2 "$f" >> final_iedb.tsv
        fi

    done

    # -------------------------
    # IEDB HEADER CHECK (FIX)
    # -------------------------

    expected_header="allele\tseq_num\tstart\tend\tlength\tpeptide\tcore\ticore\tscore\tpercentile_rank"

    if [ ! -s final_iedb.tsv ]; then
        echo -e "$expected_header" > final_iedb.tsv
        exit 0
    fi

    first_line=$(head -n 1 final_iedb.tsv)

    if [ "$first_line" != "$expected_header" ]; then
        tmp=$(mktemp)
        {
            echo -e "$expected_header"
            cat final_iedb.tsv
        } > "$tmp" && mv "$tmp" final_iedb.tsv
    fi
    '''
}
