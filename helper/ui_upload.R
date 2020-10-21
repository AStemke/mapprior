ui_upload_first_data <- box(fluidPage(
  titlePanel("Dataset 1"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("historic_1", "Use historic Data", TRUE),
      conditionalPanel(
        condition = "input.historic_1 == 1 ",
        fileInput(
          "file_1",
          "Choose CSV File",
          multiple = FALSE,
          accept = c("text/csv",
                     "text/comma-separated-values,text/plain",
                     ".csv")
        ),
        
        tags$hr(),
        checkboxInput("header", "Header", TRUE),
        
        radioButtons(
          "sep",
          "Separator",
          choices = c(
            Comma = ",",
            Semicolon = ";",
            Tab = "\t"
          ),
          selected = ","
        ),
        radioButtons(
          "quote",
          "Quote",
          choices = c(
            None = "",
            "Double Quote" = '"',
            "Single Quote" = "'"
          ),
          selected = '"'
        )
      ),
      conditionalPanel(
        condition = "input.historic_1 == 0",
        h3("Weakly informative Prior"),
        conditionalPanel(
          condition = "input.data_structure == 'Normal' || input.data_structure == 'TTE'",
          numericInput("uninf_sigma_1", "Expected Population Standard Deviation", NA)
        ),
        numericInput("uninf_mean_1", "Expected Mean", NA)),
    ),
    mainPanel(
      tableOutput("data_1_0")),
  )
))

# Second Dataset####
ui_upload_second_data <-   box(fluidPage(
  titlePanel("Dataset 2"),
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(condition = "input.n_arms >=  2",
                       checkboxInput("historic_2", "Use historic Data", TRUE),
                       conditionalPanel(
                         condition = "input.historic_2 == 1 ",
                         fileInput(
                           "file_2",
                           "Choose CSV File",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv")
                         ),
                         tags$hr(),
                         
                         checkboxInput("header_2", "Header", TRUE),
                         
                         radioButtons(
                           "sep_2",
                           "Separator",
                           choices = c(
                             Comma = ",",
                             Semicolon = ";",
                             Tab = "\t"
                           ),
                           selected = ","
                         ),
                         
                         radioButtons(
                           "quote_2",
                           "Quote",
                           choices = c(
                             None = "",
                             "Double Quote" = '"',
                             "Single Quote" = "'"
                           ),
                           selected = '"'
                         )
                         
                       ),
                       conditionalPanel(
                         condition = "input.historic_2 == 0 ",
                         h3("Weakly informative Prior"),
                         conditionalPanel(
                           condition = "input.data_structure == 'Normal' || input.data_structure == 'TTE'",
                           numericInput("uninf_sigma_2", "Expected Population Standard Deviation", NA)
                         ),
                         numericInput("uninf_mean_2", "Expected Mean", NA))
      )
      
    ),
    mainPanel(
      tableOutput("data_2_0")),
    
    
  )
  
))


# ui_upload ####
ui_upload <-   tabItem(tabName = "TabData",
                       h2("Uploading the Datasets"),
                       fluidPage(
                         fluidRow(
                           ui_upload_first_data,
                           ui_upload_second_data,
                         ),
                         verbatimTextOutput("txt_upload_data")
                       )
)

