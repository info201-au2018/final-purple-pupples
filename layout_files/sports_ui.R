sports <- 
  sidebarLayout(
    sidebarPanel(
      fluidPage(
        wellPanel(
          selectInput("team_name", h3("Search a team"), c("Bengals", "Broncos", "Buccaneers", "Panthers", "Patriots", 
                                                          "Vikings", "Seahawks", "49ers", 
                                                          "Titans", "Jets"), selected = "Seahawks"),
          submitButton("Submit")
        ),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        wellPanel(
          textInput("player_name", h3("Search a Quarterback"), value = "Russell Wilson"),
          selectInput("team_player", h3("Which team do they play for?"), c("Cowboys", "Patriots", "Packers", 
                                                                           "Steelers", "Eagles", "Saints", "Bears", 
                                                                           "Seahawks", "Vikings", "Giants", "Chiefs", 
                                                                           "Browns", "Broncos", "Texans", "Rams", 
                                                                           "Raiders", "Chargers", "Redskins", "Ravens",
                                                                           "San Francisco", "Panthers", "Dolphins", 
                                                                           "Bills", "Cardinals", "Colts", "Jets", "Lions",
                                                                           "Falcons", "Titans", "Bengals", "Jaguars",
                                                                           "Buccaneers"), selected = "Seahawks"),
          submitButton()
        )
      )
    ),
    mainPanel(
     titlePanel("Tweets in the NFL"),
     img(src = 'icon.jpg', align = "right", height = 80, width = 100),
     p("Look at how the number of tweets from your favorite teams most recent game, by clustering
       tweets around equal intervals of the game you may be able to draw a conclusion about the 
       correlation between number and tweets and big plays!"),
     plotOutput("sports"),

     titlePanel("Your Favorite Quarterback"),
     p("Have a favorite quarterback? Want to know how many touchdowns they have had each season
       over their whole entire carreer? All you have to do is type in your quarterback's first and
       last name and choose which team they currently play for and enjoy!"),
     plotOutput("player")
    )
  )
