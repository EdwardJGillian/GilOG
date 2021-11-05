#' Gene length size calculation
#'
#' This function calculates the gene length and size and
#' selects the columns needed for further processing
#'
#' @param organism - dataframe with organism data
#' @param genes - data with gene data
#'
#' @return gpo_length_size - a dataframe with gene lengths and sizes
#'
#' @import dplyr
#' @importFrom magrittr %>%
#'
#' @export
#'
gene_length_size_calc <- function(organism, genes) {
  # create genes per organism count
  gpo_length_size <-
    dplyr::left_join(organism, genes, by = "assembly") %>%
    dplyr::select(organism, assembly, protein_id, protein, gene_name, location_start, location_end) %>%
    dplyr::rename(protein_description = protein) %>%
    dplyr::arrange(organism, protein_id) %>%
    dplyr::mutate(gene_length = location_end - location_start) %>%
    dplyr::mutate(gene_size = location_start - dplyr::lag(location_end, n = 1, default = 0))
  return(gpo_length_size)
}
