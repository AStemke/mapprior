#
# This is a Shiny web application. You can run the application by adapting your Working
# directory to the location where you have unzipped the Shiny_MAP_Prior file
# and run the code below
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


wd <- "C:/R-4.0.2/Shiny_MAP_Prior"
wd_helper <- paste0(wd, "/helper") 
setwd(wd_helper)

if(!require(rmarkdown)){install.packages("rmarkdown")}; library(rmarkdown)
if(!require(shiny)){install.packages("shiny")}; library(shiny)
if(!require(shinydashboard)){install.packages("shinydashboard")}; library(shinydashboard)
if(!require(shinydashboardPlus)){install.packages("shinydashboardPlus")}; library(shinydashboardPlus)
if(!require(rhandsontable)) install.packages("rhandsontable"); library(rhandsontable)
if(!require(shinycssloaders)){install.packages("shinycssloaders")}; library(shinycssloaders)
if(!require(shinyBS)){install.packages("shinyBS")}; library(shinyBS)
if(!require(reactlog)){installed.packages("reactlog")}; library(reactlog)
if(!require(RBesT)){install.packages("RBesT")}; library(RBesT)




source("./helper_config.R")
# source("./MAP_Report.Rmd")
source("./txt_files_shiny_map.R")
source("./shiny_func_MAP_Prior.R")
source("./ui_general.R")
source("./ui_upload.R")
source("./ui_rec_config.R")
source("./ui_mcmc.R")
source("./ui_output.R")
source("./ui_download.R")
source("./ui_help.R")
source("./ui.R")
source("./server.R")




# Run the application 
shinyApp(server = server, ui = ui)

