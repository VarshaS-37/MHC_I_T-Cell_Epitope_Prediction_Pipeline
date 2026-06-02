process SELECT_TOP_EPITOPES {

    publishDir "results", mode: 'copy'

    input:
    path final_tsv
    val top_n
    val pident_cutoff

    output:
    path "top_epitopes.tsv"

    script:
    """
    python3 << 'EOF'

    import pandas as pd

    # ---------------- LOAD ----------------
    df = pd.read_csv("$final_tsv", sep="\\t")

    # ---------------- NUMERIC ----------------
    df["score"] = pd.to_numeric(
        df["score"],
        errors="coerce"
    )

    df["pident"] = pd.to_numeric(
        df["pident"],
        errors="coerce"
    )

    # ---------------- REMOVE HIGH HUMAN SIMILARITY ----------------
    filtered = df[
        (df["pident"].isna()) |
        (df["pident"] < $pident_cutoff)
    ]

    # ---------------- FALLBACK ----------------
    # if no epitopes remain, use original dataframe

    if filtered.empty:

        print(
            "WARNING: No epitopes passed pident cutoff. "
            "Using unfiltered epitopes."
        )

        filtered = df.copy()

    # ---------------- SORT ----------------
    filtered = filtered.sort_values(
        by="score",
        ascending=False
    )

    # ---------------- REMOVE DUPLICATES ----------------
    filtered = filtered.drop_duplicates(
        subset=["peptide"]
    )

    # ---------------- SELECT TOP N PER ALLELE ----------------
    selected = []

    for allele, group in filtered.groupby("allele"):

        top = group.head($top_n)

        selected.append(top)

    final = pd.concat(selected)

    # ---------------- FINAL SORT ----------------
    final = final.sort_values(
        by="score",
        ascending=False
    )

    # ---------------- SAVE ----------------
    final.to_csv(
        "top_epitopes.tsv",
        sep="\\t",
        index=False
    )

    print("\\nFinal epitopes selected:", len(final))

    EOF
    """
}
