sports <- 
  sidebarLayout(
    sidebarPanel(
      fluidPage(
        wellPanel(
          selectInput("team_name", h3("Search a team"), c("Cowboys", "Patriots", "Packers", 
                                                          "Steelers", "Eagles", "Saints", "Bears", 
                                                          "Seahawks", "Vikings", "Giants", "Chiefs", 
                                                          "Browns", "Broncos", "Texans", "Rams", 
                                                          "Raiders", "Chargers", "Redskins", "Ravens",
                                                          "San Francisco", "Panthers", "Dolphins", 
                                                          "Bills", "Cardinals", "Colts", "Jets", "Lions",
                                                          "Falcons", "Titans", "Bengals", "Jaguars",
                                                          "Buccaneers"), selected = "Seahawks"),
          selectInput("week", h3("Choose a week"), list(13,12), selected = 13),
          submitButton("Submit")
        ),
        hr(),
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
     plotOutput("sports"),
     plotOutput("player")
    )
  )
