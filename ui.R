source("./layout_files/pop_culture.R")
source("./layout_files/tv_shows.R")
source("./layout_files/Trends.R")
source("./server_files/Trending.R")
source("./layout_files/home_ui.R")
source("./layout_files/sports_ui.R")
library(shinythemes)
twitteR::setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
my_ui <- fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage("Twitter & Pop Culture",
             tabPanel("Home",
                      home
             ),
             tabPanel("Public Figures",
                      pop_culture
             ),
             tabPanel("Trending Topics",
                      trends
             ),
             tabPanel("Sports",
                      sports),
             tabPanel("TV Shows",
                      tv_shows)
  )
  
)

shinyUI(my_ui)