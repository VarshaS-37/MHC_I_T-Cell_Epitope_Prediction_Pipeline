process HUMAN_BLASTP {

    publishDir "results", mode: 'copy'

    input:
    path epitopes_tsv

    output:
    path "epitopes_human_similarity.tsv"

    script:
    """
    python3 << 'EOF'
    import pandas as pd
    import requests
    import time
    from Bio.Blast import NCBIXML

    df = pd.read_csv("$epitopes_tsv", sep='\\t')

    peptide_col = "peptide"

    similarities = []

    for peptide in df[peptide_col]:

        try:
            # Submit BLAST
            url = "https://blast.ncbi.nlm.nih.gov/Blast.cgi"

            params = {
                "CMD": "Put",
                "PROGRAM": "blastp",
                "DATABASE": "swissprot",
                "QUERY": peptide,
                "FILTER": "F",
                "EXPECT": "20000",
                "WORD_SIZE": "2",
                "MATRIX": "PAM30"
            }

            r = requests.post(url, data=params)

            rid = None
            for line in r.text.splitlines():
                if "RID =" in line:
                    rid = line.split("=")[1].strip()

            if not rid:
                similarities.append("NA")
                continue

            time.sleep(15)

            # Retrieve results
            result_params = {
                "CMD": "Get",
                "RID": rid,
                "FORMAT_TYPE": "XML"
            }

            r2 = requests.get(url, params=result_params)

            identity = "0"

            if "No hits found" not in r2.text:
                blast_record = NCBIXML.read(io.StringIO(r2.text))

                if blast_record.alignments:
                    hsp = blast_record.alignments[0].hsps[0]
                    identity = round((hsp.identities / hsp.align_length) * 100, 2)

            similarities.append(identity)

        except Exception:
            similarities.append("NA")

    df["human_similarity"] = similarities

    df.to_csv("epitopes_human_similarity.tsv", sep='\\t', index=False)

    EOF
    """
}
