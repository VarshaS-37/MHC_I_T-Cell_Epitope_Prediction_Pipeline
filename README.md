# T-Cell Epitope Prediction Pipeline

A Nextflow-based pipeline for automated identification and retrieval of experimentally validated T-cell epitopes associated with homologous protein sequences.

## Features

- Accepts a UniProt accession as input
- Retrieves the target protein sequence
- Performs BLAST similarity searches
- Selects top homologous sequences
- Filters hits based on user-defined percent identity threshold
- Retrieves epitope data from IEDB
- Validates and cleans downloaded TSV files
- Merges all valid epitope datasets into a single file
- Modular Nextflow DSL2 workflow

## Requirements

- Nextflow >= 24.0
- Java >= 11
- BLAST+
- Python >= 3.10
- Linux/Unix environment

## Repository Structure

```text
.
├── main.nf
├── nextflow.config
├── modules/
│   ├── fetch_sequence.nf
│   ├── blast_search.nf
│   ├── retrieve_iedb.nf
│   ├── clean_tsv.nf
│   └── merge_tsv.nf
├── bin/
├── README.md
└── .gitignore
```

## Usage

Run the pipeline with a UniProt accession:

```bash
nextflow run main.nf \
    --uniprot_id P59595 \
    --top_n 4 \
    --pident_cutoff 80
```

### Parameters

| Parameter | Description |
|-----------|-------------|
| `--uniprot_id` | UniProt accession of the target protein |
| `--top_n` | Number of top homologous sequences to retain |
| `--pident_cutoff` | Minimum percent identity threshold |

## Output

The pipeline generates a consolidated epitope file:

```text
results/
└── final_iedb.tsv
```

Additional intermediate files may be generated during execution for sequence retrieval, BLAST analysis, and epitope processing.

## Example

```bash
nextflow run main.nf \
    --uniprot_id P59595 \
    --top_n 10 \
    --pident_cutoff 80
```

## Notes

- Internet access is required for sequence and epitope retrieval.
- Invalid, empty, or error-containing TSV files are automatically filtered out before merging.
- The pipeline is designed for reproducible and scalable epitope discovery workflows.

## Author

S. Varsha
M.Sc. Bioinformatics
