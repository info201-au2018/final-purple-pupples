##This will be the entry point for the server
##and the ui, this brings both pages to one
##dependent file.

library(shiny)

source("setup.R")

#Create shiny Object.
shinyApp(ui = my_ui, server = my_server)
