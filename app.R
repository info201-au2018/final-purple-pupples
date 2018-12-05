##This will be the entry point for the server
##and the ui, this brings both pages to one
##dependent file.
library(twitteR)
library(shiny)


#Create shiny Object.

shinyApp(ui = my_ui, server = my_server)
