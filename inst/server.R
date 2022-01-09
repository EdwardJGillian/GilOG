library(shiny)
library(dplyr)
library(tidyr)
library(DT)
library(readxl)
library(ggplot2)
library(ggpubr)
library(rlang)
library(shinyWidgets)
library(summarytools)
library(GilOG)


server <- function(input, output, sessions) {
  # This reactive function uploads the organism dataset
  organism_upload <- reactive({
    req(input$file1)
    inFile1 <- input$file1
    df1 <- as.data.frame(read.csv(inFile1$datapath, header = TRUE, stringsAsFactors = FALSE))

    # Validate organism input file for number of columns and column names
    required_columns <- c('X', 'organism', 'kingdom', 'taxid', 'assembly')
    column_names <- colnames(df1)
    max_columns <- 5

    shiny::validate(
      need(ncol(df1) <= max_columns, "Your data has too many columns"),
      need(all(required_columns %in% column_names), "The column names don't match the required column names - refer to Organisms input description")

    )

    return(df1)
  })

  # This output function displays the organism dataset in table format
  output$org_table <- DT::renderDataTable({
    # load table for display
    df1 <- organism_upload()
    df1 <- df1 %>% dplyr::select(-X)
    DT::datatable(df1,
                  colnames = c("Organism", "Kingdom", "Taxonomy", "Assembly"),
                  filter = 'top',
                  options = list(
                    lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                    pageLength = 5))
  })

  output$org_table_quality <- renderUI({

    req(organism_upload())

    summarytools::st_options(use.x11 = FALSE)
    print(summarytools::dfSummary(organism_upload(),
                                  varnumbers = FALSE, valid.col = FALSE,
                                  graph.magnif = 0.8,
                                  max.string.width = 40
    ),
    method = "render",
    headings = FALSE,
    bootstrap.css = FALSE
    )
  })

  # This reactive function uploads the genes dataset
  genes_upload <- reactive({
    req(input$file2)
    inFile2 <- input$file2
    df2 <- as.data.frame(read.csv(inFile2$datapath, header = TRUE, stringsAsFactors = FALSE))

    # Validate genes input file for number of columns and column names
    required_columns <- c('X', 'assembly', 'locus_tag','protein_id', 'protein', 'gene_name', 'strand', 'location_start', 'location_end')
    column_names <- colnames(df2)
    max_columns <- 9

    shiny::validate(
       need(ncol(df2) <= max_columns, "Your data has too many columns"),
       need(all(required_columns %in% column_names), "The column names don't match the required column names - Genes input description")
    )


    return(df2)
  })

  # This output function displays the genes dataset in table format
  output$gene_table <- DT::renderDataTable({
    # load table for display
    df2 <- genes_upload()
    df2 <- df2 %>% dplyr::select(-X, -strand)
    DT::datatable(df2,
                  colnames = c("Assembly", "Locus Tag", "Protein", "Description", "Gene", "Start", "End"),
                  filter = 'top',
                  options = list(
                    lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                    pageLength = 5))

  })

  output$genes_table_quality <- renderUI({

    req(genes_upload())
    summarytools::st_options(use.x11 = FALSE)
    print(summarytools::dfSummary(genes_upload(),
                     varnumbers = FALSE, valid.col = FALSE,
                     graph.magnif = 0.8,
                     max.string.width = 40
    ),
    method = "render",
    headings = FALSE,
    bootstrap.css = FALSE
    )
  })

  # Data summary count
  summary_prep_df <- reactive({
     req(organism_upload)
     req(genes_upload)
  # load organism and genes for further processing
     organism <- organism_upload()
     genes <- genes_upload()
     df3 <- GilOG::summary_count_processing(organism, genes)
     return(df3)
   })

  output$summary_count <- DT::renderDT({
     summary_count_df <- summary_prep_df()
     DT::datatable(summary_count_df,
                   colnames=c("Number of organisms", "Number of genes", "Number of empty organisms"),
                   options = list(lengthChange = FALSE,
                                  bFilter = 0, # global search box off
                                  bInfo = 0, # information off
                                  paging = FALSE) # disable pagination
                   )

   })

  # Genes per organism count
  gpo_prep_df <- reactive({
    req(organism_upload)
    req(genes_upload)
    # load organism and genes for further processing
    organism <- organism_upload()
    genes <- genes_upload()
    df4 <- GilOG::gpo_processing(organism, genes)
    return(df4)
  })

  output$gpo_count <- DT::renderDT({
    gpo_count_df <- gpo_prep_df()
    DT::datatable(gpo_count_df,
                  colnames=c("Organisms", "Number of genes"),
                  options = list(
                    lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                    pageLength = 5) # disable pagination
    )
  })

  # create data frame with gene lengths and sizes
  gpo_ls_prep_df <- reactive({
    req(organism_upload)
    req(genes_upload)
    # load organism and genes for further processing
    organism <- organism_upload()
    genes <- genes_upload()
    df5 <- GilOG::gene_length_size_calc(organism, genes)
    return(df5)
  })

  # calculate correlation coefficients
  co_ef_df <- reactive({
    req(gpo_ls_prep_df)
    # load data frame with gene lengths and sizes for further processing
    co_ef_proc <- gpo_ls_prep_df()
    df6 <- GilOG::cor_processing(co_ef_proc)
    return(df6)
  })


  output$co_ef <- DT::renderDT({
    co_ef_df <- co_ef_df()
    DT::datatable(co_ef_df,
                  colnames=c("Organisms", "R Value"),
                  options = list(
                    lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                    pageLength = 5) # disable pagination
    )
  })

  # calculate correlation coefficients top 5
  gpo_ls_top_5_df <- reactive({
    req(gpo_ls_prep_df)
    # load data frame with gene lengths and sizes for further processing
    co_ef_proc <- gpo_ls_prep_df()
    df7 <- GilOG::cor_processing_top_5(co_ef_proc)
    return(df7)
  })

  # preparation for box plot
  gpo_box_df <- reactive({
    req(gpo_ls_top_5_df)
    req(organism_upload)
    # load data frame with gene lengths and sizes for further processing
    gpo_prep_box <- gpo_ls_top_5_df()
    # load organism and genes for further processing
    organism <- organism_upload()
    df8 <- gpo_prep_box %>%
      dplyr::mutate_at(vars(organism), as.factor)
    return(df8)
  })

  output$boxplot <- renderPlot({
    p <- ggplot2::ggplot(gpo_box_df(), aes(x = organism, y = gene_length, fill = organism)) +
      geom_boxplot() +
      labs(title = "Plot of length per Organism",x = "Organism", y = "Length")
    p + theme(
      plot.title = element_text(color = "red", size = 18, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 16, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 16, face = "bold"),
      legend.title = element_text(colour = "blue", size = 10, face = "bold"),
      legend.text = element_text(colour = "red", size = 10, face = "bold"),
      legend.background = element_rect(fill = "lightblue",
                                       size = 0.5, linetype = "solid",
                                       colour = "darkblue")
    )
  })

  # calculate and display scatterplot
  output$scatterplot <- renderPlot({
    gpo_length_size_top_5 <- gpo_ls_top_5_df()
    p <- GilOG::cor_scatterplot(gpo_length_size_top_5)
    p +
      font("title", size = 18, color = "red", face = "bold.italic") +
      font("xlab", size = 16, color = "blue", face = "bold") +
      font("ylab", size = 16, color = "#993333", face = "bold") +
      font("legend.title", color = "blue", face = "bold") +
      font("legend.text", size = 10, color = "red")
  })

  # calculate and display Regression Curves
  output$regcurve <- renderPlot({
    gpo_length_size_top_5 <- gpo_ls_top_5_df()
    p <- ggplot2::ggplot(gpo_length_size_top_5, aes(x = gene_size, y = gene_length, color = organism)) +
      geom_point() +
      # geom_smooth(method = "lm", fill = NA) +
      geom_smooth(method = 'lm',size = 1, colour = 'blue', formula = y ~ x + I(x^2), level = 0.99, linetype = "dashed") + theme_bw() +
      labs(title = "Regression Curves per Organism",x = "Size", y = "Length")
    p + theme(
      plot.title = element_text(color="red", size=18, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 16, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 16, face = "bold"),
      legend.title = element_text(colour = "blue", size = 10, face = "bold"),
      legend.text = element_text(colour = "red", size = 10, face = "bold"),
      legend.background = element_rect(fill = "lightblue",
                                       size = 0.5, linetype = "solid",
                                       colour = "darkblue")
    )
  })

  # common function to render DT data table
  render_DT_data_table <- function(.data) {
    DT::renderDataTable(.data(),
                        colnames = c("Genes", "Protein", "Description", "Gene", "Start", "End", "Length",  "Size"),
                        filter = 'top',
                        options = list(
                          lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
                          pageLength = 15))
  }

  # prepare output stats for 1st table
  gpo_1_df <- reactive({
    req(gpo_ls_top_5_df)
    # load data frame with gene lengths and sizes for further processing
    group_id <- as.double(1)
    gpo_prep_table_1 <- gpo_ls_top_5_df()
    df9 <- GilOG::gpo_output_processing(gpo_prep_table_1, group_id)
    return(df9)
  })

  output$gpo_stats_1 <- render_DT_data_table(
    reactive(gpo_1_df())
  )

  # Downloadable csv of selected dataset ----
  output$download_data_1 <- downloadHandler(
    filename = function() {
      paste("dataset-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(gpo_1_df(), file)
    }
  )


  # prepare output stats for 2nd table
  gpo_2_df <- reactive({
    req(gpo_ls_top_5_df)
    # load data frame with gene lengths and sizes for further processing
    group_id <- as.double(2)
    gpo_prep_table_2 <- gpo_ls_top_5_df()
    df10 <- GilOG::gpo_output_processing(gpo_prep_table_2, group_id)
    return(df10)
  })

  output$gpo_stats_2 <- render_DT_data_table(
    reactive(gpo_2_df())
  )

  # prepare output stats for 3rd table
  gpo_3_df <- reactive({
    req(gpo_ls_top_5_df)
    # load data frame with gene lengths and sizes for further processing
    group_id <- as.double(3)
    gpo_prep_table_3 <- gpo_ls_top_5_df()
    df11 <- GilOG::gpo_output_processing(gpo_prep_table_3, group_id)
    return(df11)
  })

  output$gpo_stats_3 <- render_DT_data_table(
    reactive(gpo_3_df())
  )

  # prepare output stats for 4th table
  gpo_4_df <- reactive({
    req(gpo_ls_top_5_df)
    # load data frame with gene lengths and sizes for further processing
    group_id <- as.double(4)
    gpo_prep_table_4 <- gpo_ls_top_5_df()
    df12 <- GilOG::gpo_output_processing(gpo_prep_table_4, group_id)
    return(df12)
  })

  output$gpo_stats_4 <- render_DT_data_table(
    reactive(gpo_4_df())
  )

  # prepare output stats for 5th table
  gpo_5_df <- reactive({
    req(gpo_ls_top_5_df)
    # load data frame with gene lengths and sizes for further processing
    group_id <- as.double(5)
    gpo_prep_table_5 <- gpo_ls_top_5_df()
    df13 <- GilOG::gpo_output_processing(gpo_prep_table_5, group_id)
    return(df13)
  })

  output$gpo_stats_5 <- render_DT_data_table(
    reactive(gpo_5_df())
  )
}

