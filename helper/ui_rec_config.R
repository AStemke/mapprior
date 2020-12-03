## Necessary Config ####
ui_rec_config <-   tabItem(
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
              condition = "input.endpoint_type == 'Normal'|| input.endpoint_type == 'TTE'",
              numericInput("sigma_1", "Population Standard Deviation", NA)),
            numericInput("tau_1", "Tau Prior", NA, min = 0, step = 0.05),
            numericInput("Nc_min_1", "Mixture components minimum", 1, min = 1),
            numericInput("Nc_max_1", "Mixture components maximum", 5, min = 1),
            checkboxInput("weight_1", "Weighting the studies", TRUE)
          ),
          
         mainPanel(tableOutput("tau_recom_1"))
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
                               condition = "input.endpoint_type == 'Normal' || input.endpoint_type == 'TTE'",
                               numericInput("sigma_2", "Population Standard Deviation", NA)),
                             numericInput("tau_2", "Tau Prior", NA, min = 0, step = 0.05),
                             numericInput("Nc_min_2", "Mixture components minimum", 1, min = 1),
                             numericInput("Nc_max_2", "Mixture components maximum", 5, min = 1),
                             checkboxInput("weight_2", "weighting the studies", TRUE)
            )
            
          ),
          
          mainPanel(
            conditionalPanel(
              condition = "input.n_arms >= 2",
              tableOutput("tau_recom_2")
            ))
          
        )
      ))
    ),
    div(txt_recommended_configurations)
    
  )

)

