#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Please adapt your Workingdirectory where you habe unzipped the Shiny_MAP_Prior file

wd <- "C:/R-4.0.2/Shiny_MAP_Prior"
wd_helper <- paste0(wd, "/helper") 
setwd(wd_helper)

if(!require(shiny)){install.packages("shiny")}
if(!require(shinydashboard)){install.packages("shinydashboard")}
if(!require(shinydashboardPlus)){install.packages("shinydashboardPlus")}
if(!require(shinycssloaders)){install.packages("shinycssloaders")}
if(!require(shinyBS)){install.packages("shinyBS")}
if(!require(reactlog)){installed.packages("reactlog")}
if(!require(RBesT)){install.packages("RBesT")}

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinycssloaders)
library(shinyBS)
library(reactlog)
library(RBesT)


source("./helper_config.R")
source("./txt_files_shiny_map.R")
source("./shiny_func_MAP_Prior.R")
source("./ui_general.R")
source("./ui_upload.R")
source("./ui_nec_config.R")
source("./ui_output.R")
source("./ui.R")
source("./server.R")



options(shiny.reactlog=TRUE)

# Run the application 
shinyApp(ui = ui, server = server)

