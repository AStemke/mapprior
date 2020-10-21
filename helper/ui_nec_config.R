## Necessary Config ####
ui_nec_config <-   tabItem(
  tabName = "TabConfigNec",
  h2("Recommended Configurations"),
  fluidPage(
    fluidRow(
      box(fluidPage(
        # Panel title ----
        titlePanel("Configurate Dataset 1"),
        sidebarLayout(
          sidebarPanel(
            conditionalPanel(
              condition = "input.data_structure == 'Normal'|| input.data_structure == 'TTE'",
              numericInput("sigma_1", "Population Standard Deviation", NA)),
            numericInput("tau_1", "Tau Prior", NA, min = 0, step = 0.05),
            numericInput("Nc_min_1", "Mixture components minimum", 1, min = 1),
            numericInput("Nc_max_1", "Mixture components maximum", 5, min = 1)
          ),
          
          mainPanel(tableOutput("data_1_1"))
        )
      )
      ),
      box(fluidPage(
        # Panel title ----
        titlePanel("Configurate Dataset 2"),
        sidebarLayout(
          sidebarPanel(
            conditionalPanel(condition = "input.n_arms >=  2",
                             conditionalPanel(
                               condition = "input.data_structure == 'Normal' || input.data_structure == 'TTE'",
                               numericInput("sigma_2", "Population Standard Deviation", NA)),
                             numericInput("tau_2", "Tau Prior", NA, min = 0, step = 0.05),
                             numericInput("Nc_min_2", "Mixture components minimum", 1, min = 1),
                             numericInput("Nc_max_2", "Mixture components maximum", 5, min = 1)
            )
            
          ),
          
          # Main panel for displaying outputs ----
          mainPanel(# Output: Data file ----
                    tableOutput("data_2_1"))
          
        )
      ))
    ),
    verbatimTextOutput("txt_recommended_configurations")
  )

)

