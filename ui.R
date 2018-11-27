source("./layout_files/pop_culture.R")

my_ui <- navbarPage("Pop Culture",
                 tabPanel("Public Figures",
                          pop_culture
                          ),
                 tabPanel("Sports"),
                 tabPanel("Viral Trends"),
                 tabPanel("TV Shows")
)

shinyUI(my_ui)