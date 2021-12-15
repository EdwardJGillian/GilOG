library(GilOG)
library(testthat)

test_chained_functions <- function(csv_file1, csv_file2) {
   # set testthat edition to 2 to run expect_known_value
   testthat::local_edition(2)
   test_that("check file values for parameters", {
      # naming helper
      tname <- function(n) {
         paste0(home,
                "/data/known_value/",
                csv,
                ".",
                n,
                ".rds"
         )
      }

      # create file path to csv file examples

      csv_path1 <-
         paste0(home, "/data/known_csv_input/", csv_file1)
      csv <- stringr::str_remove(csv_file1, ".csv")
      df1 <- as.data.frame(read.csv(file=csv_path1, na.strings = ""))

      csv_path2 <-

         paste0(home, "/data/known_csv_input/", csv_file2)
      df2 <- as.data.frame(read.csv(file=csv_path2, na.strings = ""))

      organism <- df1


      testthat::expect_known_value(
         organism, tname("organism"))

      genes <- df2


      testthat::expect_known_value(
         genes, tname("genes"))

      # dplyr needs to be run inside testthat for function to work
      # generates a warning
      suppressWarnings(library(dplyr))
      summary_count_df <- GilOG::summary_count_processing(organism, genes)


      testthat::expect_known_value(
         summary_count_df, tname("summary_count_df"))

      gpo_count_df <- GilOG::gpo_processing(organism, genes)

      testthat::expect_known_value(
         gpo_count_df, tname("gpo_count_df"))

      gpo_length_size <- GilOG::gene_length_size_calc(organism, genes)


      testthat::expect_known_value(
         gpo_length_size, tname("gpo_length_size"))

      co_ef_df <- GilOG::cor_processing(gpo_length_size)


      testthat::expect_known_value(
         co_ef_df, tname("co_ef_df"))

      gpo_length_size_top_5 <- GilOG::cor_processing_top_5(gpo_length_size)


      testthat::expect_known_value(
         gpo_length_size_top_5, tname("gpo_length_size_top_5"))

      group_id <- as.double(1)
      gpo_1 <- GilOG::gpo_output_processing(gpo_length_size_top_5, group_id)


      testthat::expect_known_value(
         gpo_1, tname("gpo_1"))

      group_id <- as.double(2)
      gpo_2 <- GilOG::gpo_output_processing(gpo_length_size_top_5, group_id)


      testthat::expect_known_value(
         gpo_2, tname("gpo_2"))

      group_id <- as.double(3)
      gpo_3 <- GilOG::gpo_output_processing(gpo_length_size_top_5, group_id)


      testthat::expect_known_value(
         gpo_3, tname("gpo_3"))

      group_id <- as.double(4)
      gpo_4 <- GilOG::gpo_output_processing(gpo_length_size_top_5, group_id)


      testthat::expect_known_value(
         gpo_4, tname("gpo_4"))


      group_id <- as.double(5)
      gpo_5 <- GilOG::gpo_output_processing(gpo_length_size_top_5, group_id)


      testthat::expect_known_value(
         gpo_5, tname("gpo_5"))

   })
}

# create the ALS file path
home <- setwd(Sys.getenv("HOME"))


csv_file_path <- file.path(getwd())
csv_file_path <- file.path(home, "data/known_csv_input")

# create organism as test1.csv and genes as test2
csv_files_list1 <- list.files(path = csv_file_path, pattern = "organisms*", full.names = FALSE)
csv_files_list2 <- list.files(path = csv_file_path, pattern = "genes*", full.names = FALSE)

# apply 1 list vector to the function
# apply 2 list vector to function +
purrr::map2(csv_files_list1, csv_files_list2, test_chained_functions)
