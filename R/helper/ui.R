# Putting the Use interface together

# Header ####

header <- dashboardHeader(title = "MAP Priors")

# Sidebar ####

sidebar <-   dashboardSidebar(sidebarMenu(
  menuItem(
    "Main Page",
    tabName = "General",
    icon = icon("info-circle")
  ),
  menuItem("Upload Data", tabName = "TabData", icon = icon("table")),
  menuItem(
    "Recommended Configurations",
    tabName = "TabConfigNec",
    icon = icon("edit")
  ),
  menuItem(
    "Outpt",
    tabName = "Output",
    icon = icon("digital-tachograph")
  )
))

# body ####

body <- dashboardBody(tabItems(
  # First tab content
  ui_general,
  ui_upload,
  ui_nec_config,
  ui_outti

))



# Dashboard ####
ui <- dashboardPage(header, sidebar, body)

