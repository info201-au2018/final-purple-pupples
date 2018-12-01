tv_shows <- 
    sidebarLayout(
      sidebarPanel(
        fluidPage(
          #selectInput("select", label = h3("Select A TV Hashtag"), 
           #           choices = list("#KUWTK" = "#KUWTK", "#AHS" = "#AHS", "#TheVoice" = "#TheVoice"), 
            #          selected = 1),
          
          #hr(),
          textInput("text", label = h3("Search a Hashtag")),
                    submitButton(),
          radioButtons("radio", label = h3("Choose Retweets or Favorites"),
                       choices = list("Favorites" = "Favorites", "Retweets" = "Retweets"), 
                       selected = "Favorites"),
          hr(),
          radioButtons("radio2", label = h3("Choose Device"),
                       choices = list("Computer" = "computer", "Phone/Tablet" = "phone/tablet"), 
                       selected = "phone/tablet"),
          hr()
        )
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
        titlePanel("3 Top Retweets"),
        dataTableOutput({"tweetTable"}),
        fluidRow(
        plotOutput("favorites")
        ),
        titlePanel("Does Air Time Affect number of Tweets?"),
        plotOutput("TV_times")
      )
    )
