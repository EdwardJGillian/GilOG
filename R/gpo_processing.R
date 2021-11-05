#' GPO count
#'
#' Create genes per organism count
#'
#' @param organism - dataframe with organism data
#' @param genes - data with gene data
#'
#' @return gpo_count - a dataframe with genes per organism counts
#'
#' @import dplyr
#' @importFrom magrittr %>%
#'
#' @export
gpo_processing <- function(organism, genes) {
  # create genes per organism count
  gpo_count <-
    dplyr::left_join(organism, genes, by = "assembly") %>%
    dplyr::group_by(organism, assembly) %>%
    dplyr::summarise(gpo_count = n()) %>%
    dplyr::select(-assembly)
  return(gpo_count)
}

#' GPO output
#'
#' This function prepares output stats for the GPO stats tables
#' by filtering the data by group ID
#'
#' @param data - data frame with stats data
#' @param group_id_param - integer parameter with group ID
#'
#' @return group_output - filtered dataframe
#'
#' @import dplyr
#' @importFrom magrittr %>%
#'
#' @export
#'
gpo_output_processing <- function(data, group_id_param) {
  group_output <- data %>%
    dplyr::filter(group_id == group_id_param) %>%
    dplyr::select(-assembly, -group_id) %>%
    dplyr::arrange(gene_length)
  return(group_output)
}
