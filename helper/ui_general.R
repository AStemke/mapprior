# General UI####
ui_general <- tabItem(tabName = "General",
                      fluidPage(
                        fluidRow(
                          box(
                            selectInput(
                              inputId = "endpoint_type",
                              label = "Endpoint Type",
                              choices = c("Binary", "Normal", "TTE")
                            )
                          ),
                          box(
                            selectInput(
                              inputId = "n_arms",
                              label = "Number of models to fit",
                              choices = c(1,2)
                            )
                          )
                        ),
                        div(txt_main_page)
                      )
)
