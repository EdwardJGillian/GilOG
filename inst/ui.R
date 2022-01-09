library(shiny)
library(shinythemes)
library(fontawesome)

ui <- fluidPage(title = "Organisms / Genes",
                theme = shinytheme("spacelab"),
                # check if tags are working
                tags$head(tags$style(
                   HTML('
                       body, label, input, button, select {
                       font-family: "Arial";
                       }

                       .btn-file {
                        background-color: 5B81AE;
                        border-color: 5B81AE;
                        background: 5B81AE;
                       }

                      .shiny-output-error-validation {
                       color: red;
                       font-size: 18px;
                       font-weight; bold;
                      }

                      .bttn-bordered.bttn-sm {
                          width: 200px;
                          text-align: left;
                          margin-bottom : 0px;
                          margin-top : 20px;
                       }
                       '
                   )
                )),
                  tabsetPanel(type = "pills",
                      tabPanel("Data Input", icon = icon("file-excel"),
                             fileInput("file1","Upload the organisms file",
                                       accept = c(
                                          'text/csv',
                                          'text/comma-separated-values',
                                          '.csv'
                                       )),
                             tags$div(
                                HTML(paste(org_help_text))
                             ),
                             fileInput("file2","Upload the genes file",
                                       accept = c(
                                          'text/csv',
                                          'text/comma-separated-values',
                                          '.csv'
                                       )),
                             tags$div(
                                HTML(paste(gene_help_text))
                             ),
                             tabsetPanel(type = "pills",
                                tabPanel("Organism", icon = icon("table"),
                                         DT::dataTableOutput("org_table")), # tab panel display
                                tabPanel("Organism Data Quality", icon = icon("table"),
                                         shiny::htmlOutput("org_table_quality")),
                                tabPanel("Genes", icon = icon("table"),
                                         DT::dataTableOutput("gene_table")), # tab panel display
                                tabPanel("Genes Data Quality", icon = icon("table"),
                                      shiny::htmlOutput("genes_table_quality"))
                             ),
                        ),
                      tabPanel("Data Summary", icon = icon("list-alt"),
                               column(2),
                               column(8, DT::dataTableOutput('summary_count')),
                               column(2)
                      ),
                      tabPanel("Genes per organism", icon = icon("flask"),
                               column(2),
                               column(8, DT::dataTableOutput('gpo_count')),
                               column(2)
                      ),
                      tabPanel("Correlation Coefficients", icon = icon("flask"),
                               column(2),
                               column(8, DT::dataTableOutput('co_ef')),
                               column(2)
                      ),
                      tabPanel("Visualisation", icon = icon("image"),
                               tabsetPanel(type = "pills",
                                           tabPanel("Box Plot", icon = icon("boxes"),
                                                    plotOutput("boxplot", height = "300px")),
                                           tabPanel("Scatter Plot", icon = icon("object-group"),
                                                    plotOutput("scatterplot", height = "300px")),
                                           tabPanel("Regression Curves", icon = icon("object-group"),
                                                    plotOutput("regcurve", height = "300px"))
                               )
                      ),
                      tabPanel("Top 5 Stats", icon = icon("image"),
                               tabsetPanel(type = "pills",
                                           tabPanel("Genes Statistics per organism - 1st place", icon = icon("table"),
                                                    column(2),
                                                    column(8, DT::dataTableOutput('gpo_stats_1')),
                                                    br(),
                                                    # Button
                                                    downloadButton("download_data_1", "Download 1st place data"),
                                                    column(2)
                                           ),
                                           tabPanel("Gene Statistics per organism - 2nd place", icon = icon("table"),
                                                    column(2),
                                                    column(8, DT::dataTableOutput('gpo_stats_2')),
                                                    column(2)
                                           ),
                                           tabPanel("Gene Statistics per organism - 3rd place", icon = icon("table"),
                                                    column(2),
                                                    column(8, DT::dataTableOutput('gpo_stats_3')),
                                                    column(2)
                                           ),
                                           tabPanel("Gene Statistics per organism - 4th place", icon = icon("table"),
                                                    column(2),
                                                    column(8, DT::dataTableOutput('gpo_stats_4')),
                                                    column(2)
                                           ),
                                           tabPanel("Gene Statistics per organism - 5th place", icon = icon("table"),
                                                    column(2),
                                                    column(8, DT::dataTableOutput('gpo_stats_5')),
                                                    column(2)
                                           )
                               )
                      )
                  )
              )

