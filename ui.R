source("./layout_files/pop_culture.R")
source("./layout_files/tv_shows.R")
source("./layout_files/Trends.R")
source("./server_files/Trending.R")
source("./layout_files/home_ui.R")
library(shinythemes)


my_ui <- fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage("Twitter & Pop Culture",
             tabPanel("Home",
                      home
             ),
             tabPanel("Public Figures",
                      pop_culture
             ),
             tabPanel("Sports"),
             tabPanel("Trending Topics",
                      trends
             ),
             tabPanel("TV Shows",
                      tv_shows)
  )

)

shinyUI(my_ui)