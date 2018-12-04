library(ggplot2)
library(DT)


# myui <- fluidPage(
#   titlePanel(pwd())source("./server_files/Trending.R")source("./server_files/Trending.R")source("./server_files/Trending.R"),
#   # Create a new Row in the UI for selectInputs
#   fluidRow(
#     column(4,
#            selectInput("country",
#                        "Country:",
#                        c("All",
#                          unique(as.character(all_country_data$country))))
#     ),
#     column(4,
#            selectInput("url",
#                        "Link:",
#                        c("All",
#                          unique(as.character(all_country_data$url))))
#     ),
#     column(4,
#            selectInput("trend",
#                        "Trending Topic:",
#                        c("All",
#                          unique(as.character(all_country_data$trend))))
#     )
#   ),
#   # Create a new row for the table.
#   DT::dataTableOutput("table")
# )

fluidPage(
  titlePanel("HALP"),
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
           selectInput("country",
                       "Country:",
                       c("All",
                         unique(as.character(all_country_data$country))))
    ),
    column(4,
           selectInput("trend",
                       "Trending Topic:",
                       c("All",
                         unique(as.character(all_country_data$trend))))
    ),
    column(4,
           selectInput("url",
                       "Link:",
                       c("All",
                         unique(as.character(all_country_data$url))))
    )
  ),
  p(getwd()),
  # Create a new row for the table.
  DT::dataTableOutput("table")
)