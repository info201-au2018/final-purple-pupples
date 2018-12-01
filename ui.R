source("./layout_files/pop_culture.R")
source("./layout_files/tv_shows.R")
library(shinythemes)

my_ui <- fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage("Pop Culture",
             tabPanel("Public Figures",
                      pop_culture
             ),
             tabPanel("Sports"),
             tabPanel("Viral Trends"),
             tabPanel("TV Shows",
                      tv_shows)
  )

)

shinyUI(my_ui)