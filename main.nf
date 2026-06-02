nextflow.enable.dsl=2 
include { FETCH_FASTA } from './modules/fetch_fasta' 
include { IEDB_MHC } from './modules/iedb_mhc' 
include { MERGE_TSV } from './modules/merge_tsv' 
include { FILTER_EPITOPES } from './modules/filter_epitopes' 
include { CLEAN_TSV } from './modules/clean_tsv'
include { EPITOPES_TO_FASTA } from './modules/epitopes_to_fasta'
include { HUMAN_BLASTP } from './modules/human_blastp'
include { MERGE_BLAST_RESULTS } from './modules/merge_blast_results'
include { SELECT_TOP_EPITOPES } from './modules/select_top_epitopes'

workflow { 

    log.info """
    =========================================
     T CELL EPITOPE VACCINE PIPELINE
    =========================================
    """

    if (!params.uniprot_id) {
        error "Please provide UniProt ID: --uniprot_id <ID>"
    }

    
    log.info "Selected UniProt ID: ${params.uniprot_id}"
    

    fasta_ch = FETCH_FASTA(params.uniprot_id)

    allele_ch = Channel
        .fromPath("assets/hla_alleles_i.txt")
        .splitText()
        .map { it.trim() }
        .filter { it }
result_ch = IEDB_MHC(fasta_ch, allele_ch)
cleaned = CLEAN_TSV(result_ch)

merged_ch = MERGE_TSV(cleaned.collect())
    filtered = FILTER_EPITOPES(merged_ch)

    fasta_epi = EPITOPES_TO_FASTA(filtered)

    blast_res = HUMAN_BLASTP(fasta_epi)

    final_file=MERGE_BLAST_RESULTS(filtered, blast_res)
    
   SELECT_TOP_EPITOPES(
    final_file,
    params.top_n,
    params.pident_cutoff
)
    
}
