#' Correlation processing
#'
#' This function performs correlation calculations
#' @param data - data frame with gene length and size per organism
#'
#' @return correlate - dataframe with calculations
#'
#' @import dplyr
#' @importFrom stats cor
#' @importFrom magrittr %>%
#'
#' @export
#'
cor_processing <- function(data) {
   correlate <- data %>%
      dplyr::group_by(organism) %>%
      dplyr::summarise(r = stats::cor(gene_length, gene_size)) %>%
      dplyr::arrange(desc(r))


   return(correlate)
}

#' Correlation processing top 5
#'
#' This function performs correlation calculations to find the 5 strongest relationships
#' and groups by organism and add a unique sort id
#' @param data - data frame with gene length and size per organism
#'
#' @return gpo_length_size_top_5 - dataframe with calculations
#'
#' @import dplyr
#' @importFrom magrittr %>%
#'
#' @export
#'
cor_processing_top_5 <- function(data) {
   correlate_t5 <- data %>%
      dplyr::group_by(organism) %>%
      dplyr::summarise(r = cor(gene_length, gene_size)) %>%
      dplyr::arrange(desc(r)) %>%
      dplyr::slice_head(n = 5) %>% as.data.frame

   # filter for 5 strongest relationships
   data1 <- data %>% dplyr::filter(data$organism %in% correlate_t5$organism)

   # group by organism and add a unique sort id
   gpo_length_size_top_5 <- data1 %>%
      dplyr::group_by(organism) %>%
      dplyr::mutate(group_id = dplyr::cur_group_id())

   return(gpo_length_size_top_5)
}

#' Correlation calc display
#'
#' This function calculates and displays Pearson correlation coefficients
#'
#' @param data - data frame with gene length and size per organism
#'
#' @import dplyr
#' @import ggpubr
#' @importFrom magrittr %>%
#'
#' @export
#'
cor_scatterplot <- function(data) {
   ggpubr::ggscatter(data, x = "gene_length", y = "gene_size",
                     add = "reg.line", conf.int = TRUE,
                     cor.coef = TRUE, cor.method = "pearson",
                     color = "organism",
                     xlab = "Gene Length", ylab = "Gene Size",
                     title = "Scatterplot of gene length vs intergenic size")
}
