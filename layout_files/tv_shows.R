source("server.R")
tv_shows <- 
  sidebarLayout(
    sidebarPanel(
      fluidPage(
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
          textInput("text", label = h3("Search a TV Show Hashtag to view its top tweets!")),
          submitButton("Search")
        ),
        br(),
        br(),
        br(),
        br(),
        wellPanel(
          radioButtons("select2", "All Devices/ Computer/ Phone or Ipad", 
                       c("All", "Computer", "Phone/Ipad")),
          submitButton("Search")
        ),
        hr(),
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
          radioButtons("select", "Retweets/Favorites", 
                      c("Retweets", "Favorites")),
          hr(),
          selectInput("tvshow", "View one show at a time", c("All", "Keeping up with the Kardashians", 
                                                    "American Horror Story", "The Voice",
                                                    "Saturday Night Live"), selected = NULL,
                      selectize = TRUE),
          submitButton("Search")
        ),
        hr(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br()
      )
    ),
    mainPanel(
      img(src = 'icon.jpg', align = "right", height = 80, width = 100),
      titlePanel("The Influence of Television"),
      p("Explore how television brings rise to a community of Twitter users. Twitter is a platform provides
        a space for users to engage in conversation surrounding their TV show of choice. We are able
         to examine the relationship between television air-time, number of retweets, and specific shows.
         We can make generalizations about which shows are most popular, the impact of 'live-tweeting' from 
         celebrities, and more!"),
      titlePanel("Top 3 Retweets"),
      # <div> is a container element, and we're giving it the style 'position: relative'
      # which means its children will be positioned relative to it.
      # tags$div(
      #   style = 'position: relative',
      #   
      #   # <img> displays an image, and the src is relative to the www/ folder
      #   img(src = 'tweet.jpg', height = 275, width = 600),
      #   # <p> displays text, and we're giving it styles to center it
      #   p("ok", style = 'position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);')
      # ),
      dataTableOutput({"tweetTable"}),
      fluidRow(
        titlePanel("Does Air Time Affect number of Tweets?"),
        plotOutput("TV_times"),
        plotOutput("fav")
      )
  )
  )