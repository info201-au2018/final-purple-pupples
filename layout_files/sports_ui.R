sports <- 
  sidebarLayout(
    sidebarPanel(
      fluidPage(
        selectInput("team_name", h3("Search a team"), c("Cowboys", "Patriots", "Packers", 
                                                        "Steelers", "Eagles", "Saints", "Bears", 
                                                        "Seahawks", "Vikings", "Giants", "Chiefs", 
                                                        "Browns", "Broncos", "Texans", "Rams", 
                                                        "Raiders", "Chargers", "Redskins", "Ravens",
                                                        "San Francisco", "Panthers", "Dolphins", 
                                                        "Bills", "Cardinals", "Colts", "Jets", "Lions",
                                                        "Falcons", "Titans", "Bengals", "Jaguars",
                                                        "Buccaneers"), selected = "Seahawks"),
          submitButton(),
        selectInput("week", h3("Choose a week"), list(13,12,11)),
        hr()
        )
      ),
    mainPanel(
     plotOutput("sports") 
    )
  )