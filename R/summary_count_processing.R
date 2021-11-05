#' Data summary Function
#'
#' This function creates the a dataframe with the counts in various categories
#'
#' @param organism - dataframe with organism data
#' @param genes - data with gene data
#'
#' @return summary_count_df - a dataframe with category counts
#' @export
#'

summary_count_processing <- function(organism, genes) {
   # create organism count
   org_count <- organism %>%
      dplyr::distinct() %>%
      dplyr::count(X) %>%
      dplyr::summarise(org_count = n())

   # create gene count
   gen_count <- genes %>%
      dplyr::distinct() %>%
      dplyr::count(X) %>%
      dplyr::summarise(gen_count = n())

   # create empty organism count
   empty_organism_count <-
      dplyr::anti_join(organism, genes, by = "assembly") %>%
      dplyr::distinct() %>%
      dplyr::count(X) %>%
      dplyr::summarise(eo_count = n())


   # create dataframe with category counts
   summary_count_df <- org_count %>%
      dplyr::full_join(gen_count, by = character()) %>%
      dplyr::full_join(empty_organism_count, by = character())

   return(summary_count_df)
}
