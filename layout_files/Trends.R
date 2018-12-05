library(ggplot2)
library(DT)
source("./server_files/Trending.R")

trends <- fluidPage(
  img(src = 'icon.jpg', align = "right", height = 80, width = 100),
  titlePanel("Current Trending Topics on Twitter"),
  h4("Which trending topics are able to transcend national borders, and which are defined by the country itself? Explore and find out!"),
  p("Certain topics are able to unite a small community, a nation, or even the world. With online platforms like Twitter,
    there are no borders, and while that certainly makes some topics spread across the globe, other topics seem to stay 
    within a user's country. Explore the differences in topics based on country, or search for a specific topic and see 
    which countries are talking about it! "),
  p("For the interavtive page click here",
    a("Interactive page",
      href = "https://kaitlyncameron.shinyapps.io/TrendingTab/")),
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
            selectInput("link",
                        "Tweet Link:",
                         c("All",
                          unique(as.character(all_country_data$url))))
     )
   ),
   # Create a new row for the table.
   dataTableOutput({"table"})
 )


