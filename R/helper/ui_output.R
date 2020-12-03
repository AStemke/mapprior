#Shiny_MAP_Prior ui_output

ui_outti <- tabItem(
  tabName = "Output",
  h2("Output"),
  tags$head(tags$script(HTML('Shiny.addCustomMessageHandler("jsCode",function(message) {eval(message.value);});'))),
  fluidPage(
    fluidRow(
      #Regarding first Dataset
      column(
        6,
        h4("MAP Prior 1"),
        
        
        # Changing default Robustifications
        numericInput(
          "rob_1",
          "Robustness Mixture Component",
          0.2,
          min = 0,
          max = 1,
          step = 0.1
        ),
        numericInput("rob_mean_1", "Robustness Mean", NA),
        
        # Triggering event Reaction for MAP and robust
        actionButton(
          "submit_1",
          "Submit any changes",
          class = "btn-success",
          icon = icon("check-circle")
        ),
        
        tags$hr(),
        
        conditionalPanel(condition = "input.historic_1 == 1 ",
                         withSpinner(plotOutput("forest_1"))),
        conditionalPanel(condition = "input.historic_1 == 0 ",
                         verbatimTextOutput("noforest_1")),
        plotOutput("prior_dist_1"),
        tags$hr(),
        h4(span(textOutput("dist_text_1"), style = "font-weight: bold")),
        tags$hr(),
        box(
          textOutput("error_1"),
          tags$hr(),
          span(textOutput("warning_1"), style = "font-weight: bold; color: red"),
          tags$hr(),
          textOutput("message_1")
        )
      ),
      
      
      #Regarding the second Dataset
      column(
        6,
        conditionalPanel(
          condition = "input.n_arms >=  2",
          h4("MAP Prior 2"),
          numericInput(
            "rob_2",
            "Robustness Mixture Component",
            0.2,
            min = 0,
            max = 1,
            step = 0.1
          ),
          numericInput("rob_mean_2", "Robustness Mean", NA),
          
          actionButton(
            "submit_2",
            "Submit any changes",
            class = "btn-success",
            icon = icon("check-circle")
          )
        ),
        
        tags$hr(),
        
        conditionalPanel(
          condition = "input.n_arms >=  2",
          conditionalPanel(condition = "input.historic_2 == 1 ",
                           withSpinner(plotOutput("forest_2"))),
          conditionalPanel(condition = "input.historic_2 == 0 ",
                           verbatimTextOutput("noforest_2")),
          plotOutput("prior_dist_2"),
          tags$hr(),
          h4(span(textOutput("dist_text_2"), style = "font-weight: bold")),
          tags$hr(),
          box(
            textOutput("error_2"),
            tags$hr(),
            span(textOutput("warning_2"), style = "font-weight: bold; color: red"),
            tags$hr(),
            textOutput("message_2")
          )
        )
      )
    ),
    
    div(txt_output)
    
  )
)

