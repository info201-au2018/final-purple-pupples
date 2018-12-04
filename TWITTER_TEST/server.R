library(ggplot2)
library(DT)
source("../server_files/Trending.R")
# function(input, output) {
#   
#   # Filter data based on selections
#   output$table <- DT::renderDataTable(DT::datatable({
#     data <- all_country_data
#     if (input$country != "All") {
#       data <- data[data$country == input$country,]
#     }
#     if (input$url != "All") {
#       data <- data[data$url == input$url,]
#     }
#     if (input$trend != "All") {
#       data <- data[data$trend == input$trend,]
#     }
#     data
#   }))
#   
# }
# 
# library(ggplot2)

function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- all_country_data
    if (input$country != "All") {
      data <- data[data$country == input$country,]
    }
    if (input$trend != "All") {
      data <- data[data$trend == input$trend,]
    }
    if (input$url != "All") {
      data <- data[data$url == input$url,]
    }
    data
  }))
  
}