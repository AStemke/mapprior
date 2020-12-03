# General UI####
ui_general <- tabItem(tabName = "General",
                      fluidPage(
                        fluidRow(
                          box(
                            selectInput(
                              inputId = "data_structure",
                              label = "Datastructure",
                              choices = c("Binary", "Normal", "TTE")
                            )
                          ),
                          box(
                            numericInput(
                              inputId = "n_arms",
                              label = "Number of arms",
                              1, min = 1, max = 2
                            )
                          )
                          
                        ),
                        verbatimTextOutput("txt_main_page")
                        
                      )
)
