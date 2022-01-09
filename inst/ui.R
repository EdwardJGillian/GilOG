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
                                                    column(2),
                                                    # change colour of the button when clicking to red
                                                    tags$style(type = "text/css",
                                                               "#download_data_1, #download_data_1:active  {
                                                                background-color:rgba(255, 0, 0, 0.3);
                                                                color: white;
                                                                font-family: Arial;
                                                                border-color: #ddd;
                                                                -webkit-box-shadow: 0px;
                                                                box-shadow: 0px;
                                                                }
                                                    "),
                                                    # Download button
                                                    downloadButton("download_data_1", "Download 1st place data", class = "butt"),
                                                    column(2)
                                           ),
                                           tabPanel("Gene Statistics per organism - 2nd place", icon = icon("table"),
                                                    column(2),
                                                    column(8, DT::dataTableOutput('gpo_stats_2')),
                                                    column(2),
                                                    # change colour of the button when clicking to blue
                                                    tags$style(type = "text/css",
                                                               "#download_data_2, #download_data_2:active  {
                                                                background-color:rgba(0, 0, 255, 0.3);
                                                                color: white;
                                                                font-family: Arial;
                                                                border-color: #ddd;
                                                                -webkit-box-shadow: 0px;
                                                                box-shadow: 0px;
                                                                }
                                                    "),
                                                    # Download button
                                                    downloadButton("download_data_2", "Download 2nd place data", class = "butt"),
                                                    column(2)
                                           ),
                                           tabPanel("Gene Statistics per organism - 3rd place", icon = icon("table"),
                                                    column(2),
                                                    column(8, DT::dataTableOutput('gpo_stats_3')),
                                                    column(2),
                                                    # change colour of the button when clicking to green
                                                    tags$style(type = "text/css",
                                                               "#download_data_3, #download_data_3:active  {
                                                                background-color:rgba(0, 255, 0, 0.3);
                                                                color: white;
                                                                font-family: Arial;
                                                                border-color: #ddd;
                                                                -webkit-box-shadow: 0px;
                                                                box-shadow: 0px;
                                                                }
                                                    "),
                                                    # Download button
                                                    downloadButton("download_data_3", "Download 3rd place data", class = "butt"),
                                                    column(2)
                                           ),
                                           tabPanel("Gene Statistics per organism - 4th place", icon = icon("table"),
                                                    column(2),
                                                    column(8, DT::dataTableOutput('gpo_stats_4')),
                                                    column(2),
                                                    # change colour of the button when clicking to yellow
                                                    tags$style(type = "text/css",
                                                               "#download_data_4, #download_data_4:active  {
                                                                background-color:rgba(255, 255, 0, 0.3);
                                                                color: white;
                                                                font-family: Arial;
                                                                border-color: #ddd;
                                                                -webkit-box-shadow: 0px;
                                                                box-shadow: 0px;
                                                                }
                                                    "),
                                                    # Download button
                                                    downloadButton("download_data_4", "Download 4th place data", class = "butt"),
                                                    column(2)
                                           ),
                                           tabPanel("Gene Statistics per organism - 5th place", icon = icon("table"),
                                                    column(2),
                                                    column(8, DT::dataTableOutput('gpo_stats_5')),
                                                    column(2),
                                                    # change colour of the button when clicking to cerise
                                                    tags$style(type = "text/css",
                                                               "#download_data_5, #download_data_5:active  {
                                                                background-color:rgba(255, 0, 255, 0.3);
                                                                color: white;
                                                                font-family: Arial;
                                                                border-color: #ddd;
                                                                -webkit-box-shadow: 0px;
                                                                box-shadow: 0px;
                                                                }
                                                    "),
                                                    # Download button
                                                    downloadButton("download_data_5", "Download 5th place data", class = "butt"),
                                                    column(2)
                                           )
                               )
                      )
                  )
              )

