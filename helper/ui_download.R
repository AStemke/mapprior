# Shiny Map Prior Download R Markdown File
ui_download <- tabItem(
  tabName = "Download",
  h2("Download"),
  fluidPage(
    fluidRow(
      box(
        downloadButton("report", "Generate report")
      ),
      box(
       checkboxInput("detail_0", "Include graphics", TRUE) 
      ),
      box(
        verbatimTextOutput("detail_1_6"),
        verbatimTextOutput("detail_2_6"),
        checkboxInput("detail_6", "Include GoNoGo App friendly output", TRUE)
      ),
      box(
        verbatimTextOutput("detail_1_2"),
        verbatimTextOutput("detail_2_2"),
        checkboxInput("detail_2", "Include not robustified Mixture components", TRUE)
      ),
      box(
        verbatimTextOutput("detail_1_4"),
        verbatimTextOutput("detail_1_1"),
        verbatimTextOutput("detail_2_4"),
        verbatimTextOutput("detail_2_1"),
        checkboxInput("detail_1", "Include MCMC settings and results", TRUE)
      ),
      box(
        verbatimTextOutput("detail_1_3"),
        verbatimTextOutput("detail_2_3"),
        checkboxInput("detail_3", "Include robustified Mixture components", TRUE)
      ),
      box(
        verbatimTextOutput("detail_1_5_1"),
        verbatimTextOutput("detail_1_5_2"),
        verbatimTextOutput("detail_2_5_1"),
        verbatimTextOutput("detail_2_5_2"),
        checkboxInput("detail_5", "Include information about used components", TRUE)
      )
    )
  )
)
