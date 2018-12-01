pop_culture <- sidebarLayout(
  sidebarPanel(
    textInput("public_figure", h4("Which public figure would you like to look up?")),
    submitButton("Search"),
    selectInput("num_of_tweets", h5("How many tweets would you like to look at?"), c(100, 500, 1000)),
    textInput("user1", h4("Lets compare public figures. Please enter the first user."), "realDonaldTrump"),
    submitButton("Search"),
    textInput("user2", h4("Pleae enter the second user."), "BarackObama"),
    submitButton("Search"),
    checkboxGroupInput("checks", h5("What should we compare?"), choices = c("Description", "Favorites", 
                                                                            "Retweets", "Followers",
                                                                            "Most recent tweet",
                                                                            "Verified Status"), 
                 selected = "Description")
  ),
  mainPanel(
    tags$head(
      tags$style(
        "
        .title 
        {
        background:url('www/image.png');
        background-repeat: no-repeat;
        background-size: 5% 90%;
        }
        "
      )
    ),
    img(src = 'icon.jpg', align = "right", height = 80, width = 100),
    h3(textOutput("word_cloud_text")),
    plotOutput(outputId = "public_figure_word_cloud", width = "500%", height = "500%")
  )
)
