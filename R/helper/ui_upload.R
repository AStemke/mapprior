ui_upload_first_data <- box(fluidPage(
  titlePanel("Dataset 1"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("historic_1", "Use historical Data", TRUE),
      conditionalPanel(
        condition = "input.historic_1 == 1 ",
        selectInput(
          "format_1",
          "Choose data format",
          choices = c("CSV", "RDS"),
          selected = "CSV"
        ),
        
        conditionalPanel(
          condition = "input.format_1 == 'CSV' ",
          fileInput(
            "csv_file_1",
            "Choose CSV File",
            multiple = FALSE,
            accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")
          ),
          
          
          tags$hr(),
          checkboxInput("csv_header_1", "Header", TRUE),
          
          radioButtons(
            "csv_sep_1",
            "Separator",
            choices = c(
              Comma = ",",
              Semicolon = ";",
              Tab = "\t"
            ),
            selected = ","
          ),
          radioButtons(
            "csv_quote_1",
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
          condition = "input.format_1 == 'RDS' ",
          fileInput(
            "rds_file_1",
            "Choose RDS File",
            multiple = FALSE,
            accept = c(".rds")
          )
        ),
        
        tags$hr(),
        
        h4("Enter here the regarding column names of your uploaded data set."),
        
        textInput("study_1", "Group Variable", "study"),
        conditionalPanel(
          condition = "input.endpoint_type == 'Binary'",
          textInput("n_binary_1", "Number of subjects Variable", "n"),
          textInput("r_1", "Number of Responders Variable", "r")
        ),
        conditionalPanel(
          condition = "input.endpoint_type == 'Normal'",
          textInput("n_normal_1", "Number of subjects Variable", "n"),
          textInput("y_1", "Summary Statistic", "y")
        ),
        conditionalPanel(
          condition = "input.endpoint_type == 'TTE'",
          textInput("hr_1", "Hazard Ratio Variable", "hr"),
          textInput("eventsobs_1", "Events observed Variable", "eventsobs"),
          textInput("k_1", "k:1 randomization Variable", "k"),
        )
      ),
      conditionalPanel(
        condition = "input.historic_1 == 0",
        h3("Weakly informative Prior"),
        conditionalPanel(
          condition = "input.endpoint_type == 'Binary'",
          numericInput("uninf_mean_binary_1", "Response Rate", NA)
        ),
        conditionalPanel(
          condition = "input.endpoint_type == 'Normal'",
          numericInput("uninf_mean_normal_1", "Mean", NA),
          numericInput("uninf_sigma_normal_1", "Population Standard Deviation", NA)
        ),
        conditionalPanel(
          condition = "input.endpoint_type == 'TTE'",
          numericInput("uninf_mean_tte_1", "Hazard Ratio", NA),
          numericInput("uninf_sigma_tte_1", "Population Standard Deviation", 2)
        )
      ),
    ),
    mainPanel(
      conditionalPanel("input.historic_1 == 1",
                       rHandsontableOutput("data_out_1"))
    ),
  )
))

# Second Dataset####
ui_upload_second_data <-   box(fluidPage(
  titlePanel("Dataset 2"),
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition = "input.n_arms >=  2",
        checkboxInput("historic_2", "Use historical Data", TRUE),
        conditionalPanel(
          condition = "input.historic_2 == 1 ",
          selectInput(
            "format_2",
            "Choose data format",
            choices = c("CSV", "RDS"),
            selected = "CSV"
          ),
          
          conditionalPanel(
            condition = "input.format_2 == 'CSV' ",
            fileInput(
              "csv_file_2",
              "Choose CSV File",
              multiple = FALSE,
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")
            ),
            
            
            tags$hr(),
            checkboxInput("csv_header_2", "Header", TRUE),
            
            radioButtons(
              "csv_sep_2",
              "Separator",
              choices = c(
                Comma = ",",
                Semicolon = ";",
                Tab = "\t"
              ),
              selected = ","
            ),
            radioButtons(
              "csv_quote_2",
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
            condition = "input.format_2 == 'RDS' ",
            fileInput(
              "rds_file_2",
              "Choose RDS File",
              multiple = FALSE,
              accept = c(".rds")
            )
          ),
          
          
          
          tags$hr(),
          
          h4("Enter here the regarding column names of your uploaded data set."),
          
          textInput("study_2", "Group Variable", "study"),
          conditionalPanel(
            condition = "input.endpoint_type == 'Binary'",
            textInput("n_binary_2", "Number of subjects Variable", "n"),
            textInput("r_2", "Number of Responders Variable", "r")
          ),
          conditionalPanel(
            condition = "input.endpoint_type == 'Normal'",
            textInput("n_normal_2", "Number of subjects Variable", "n"),
            textInput("y_2", "Summary Statistic", "y")
          ),
          conditionalPanel(
            condition = "input.endpoint_type == 'TTE'",
            textInput("hr_2", "Hazard Ratio Variable", "hr"),
            textInput("eventsobs_2", "Events observed Variable", "eventsobs"),
            textInput("k_2", "k:1 randomization Variable", "k")
          )
          
        ),
        conditionalPanel(
          condition = "input.historic_2 == 0 ",
          h3("Weakly informative Prior"),
          conditionalPanel(condition = "input.endpoint_type == 'Binary'",
                           numericInput("uninf_mean_binary_2", "Response Rate", NA)),
          conditionalPanel(
            condition = "input.endpoint_type == 'Normal'",
            numericInput("uninf_mean_normal_2", "Mean", NA),
            numericInput("uninf_sigma_normal_2", "Population Standard Deviation", NA)
          ),
          conditionalPanel(
            condition = "input.endpoint_type == 'TTE'",
            numericInput("uninf_mean_tte_2", "Hazard Ratio", NA, min = 0),
            numericInput("uninf_sigma_tte_2", "Population Standard Deviation", 2)
          )
        )
      )
      
    ),
    mainPanel(
      conditionalPanel(condition = "input.n_arms >=  2 && input.historic_2 == 1",
                       rHandsontableOutput("data_out_2"))
    ),
    
  )
  
))


# ui_upload ####
ui_upload <-   tabItem(tabName = "TabData",
                       h2("Uploading the Datasets"),
                       fluidPage(
                         #useShinyjs(), #for resetting input values
                         fluidRow(ui_upload_first_data,
                                  ui_upload_second_data,),
                         verbatimTextOutput("txt_upload_data")
                       ))
