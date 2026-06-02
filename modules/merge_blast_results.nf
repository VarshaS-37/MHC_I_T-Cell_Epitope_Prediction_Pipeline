process MERGE_BLAST_RESULTS {

    publishDir "results", mode: 'copy'

    input:
    path epitopes
    path blast

    output:
    path "final_epitopes_with_human_similarity.tsv"

    script:
    """
    python3 << 'EOF'
    import pandas as pd

    epi = pd.read_csv("$epitopes", sep="\\t")

    blast = pd.read_csv(
        "$blast",
        sep="\\t",
        header=None,
        names=[
            "qid",
            "human_protein",
            "pident",
            "length",
            "evalue",
            "bitscore"
        ]
    )

    blast = blast.sort_values(
        "bitscore",
        ascending=False
    ).drop_duplicates("qid")

    epi["qid"] = [f"pep{i+1}" for i in range(len(epi))]

    merged = epi.merge(
        blast,
        on="qid",
        how="left"
    )

    merged.to_csv(
        "final_epitopes_with_human_similarity.tsv",
        sep="\\t",
        index=False
    )
    EOF
    """
}
