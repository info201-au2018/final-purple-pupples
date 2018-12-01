pop_culture <- sidebarLayout(
  sidebarPanel(
    wellPanel(
      textInput("public_figure", "Which public figure would you like to look up?"),
      submitButton("Search")
    ),
    selectInput("num_of_tweets", "How many tweets would you like to look at?", c(100, 500, 1000))
  ),
  mainPanel(
    h1(textOutput("word_cloud_text")),
    plotOutput(outputId = "public_figure_word_cloud", width = "500%", height = "500%")
  )
)
