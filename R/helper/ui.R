# Putting the Use interface together

# Header ####

header <- dashboardHeader(
  title = "MAP Priors",
  tags$li(class = "dropdown", tags$a(HTML(paste(textOutput("gen_info"), "Endpoint"))))
  )
  

# Sidebar ####

sidebar <-   dashboardSidebar(sidebarMenu(
  menuItem(
    "Main Page",
    tabName = "General",
    icon = icon("home")
  ),
  menuItem("Upload Data", tabName = "TabData", icon = icon("table")),
  menuItem(
    "Recommended Configurations",
    tabName = "TabConfigNec",
    icon = icon("edit")
  ),
  menuItem(
    "Change MCMC Settings",
    tabName = "mcmc",
    icon = icon("dice")
  ),
  menuItem(
    "Fit the model",
    tabName = "Output",
    icon = icon("digital-tachograph")
  ),
  menuItem(
    "Download Results",
    tabName = "Download",
    icon = icon("file-download")
  ),
  menuItem(
    "Help",
    tabName = "Help",
    icon = icon("info-circle")
     )
))

# body ####

body <- dashboardBody(tabItems(
  # First tab content
  ui_general,
  ui_upload,
  ui_rec_config,
  ui_mcmc,
  ui_outti,
  ui_download,
  ui_help

))



# Dashboard ####
ui <- dashboardPage(header, sidebar, body)

