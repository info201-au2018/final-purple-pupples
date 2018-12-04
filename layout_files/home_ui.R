

# Define UI ----
home <- fluidPage(
  titlePanel("The Influence Twitter and Pop-Culture Have on One Another"),
  sidebarLayout(
    sidebarPanel(
      h2("Meet The Team"),
      h5("CJ Hillbrand"),
      img(src = 'cj.jpg', height = 150, width = 150),
      p("CJ is everyone's favorite CSE TA:) When it comes to coding, CJ is the guy for you! He also just became the new
        President of Pi Kappa Phi!"),
      br(),
      
      h5("Nina Slazinik"),
      img(src = 'nina.jpg', height = 150, width = 150),
      br(),
      p("Nina is currently studying business, and hopes to incorporate her passion of informatics in her work.
        Nina's fun fact is that she is an identical twin!"),
      br(),
      
      h5("Kaitlyn Cameron"),
      img(src = 'kaitlyn.jpg', height = 150, width = 150),
      p("Kaitlyn loves that the Information School is bringing her one step closer to her future with user experience 
        and design work. She can't wait until the winter to journey to the mountains!"),
      br(),
      
      h5("Colette Lertkantitham"),
      img(src = 'colette.jpg', height = 150, width = 150),
      p("Colette has a passion for all things engineering and all things tech! She's a die hard husky fan and loves spending
        her time surrounded by Dogs&Dawgs"),
      br()
      
    ),
    mainPanel(
      img(src = 'icon.jpg', align = "right", height = 80, width = 100),
      h2("Rise of the 'TwitterVerse'"),
      p("Twitter functions as a real-time information network, but has become increasingly influential 
        in the area of cross-cultural engagement. The diversity of the site’s user base and its open 
        architecture have led a wide range of cultural groups and an equally wide range of ",
        em("pop-culture"),
        "groups to interact with others within or outside of their normal circle."),
      br(),
      img(src = 'tweet.png', align = "left", height = 250, width = 250),
      p("Cultural activities are taking place in full view of others who may be unfamiliar with the 
        topic they are observing. This inevitably leads to some level of exploration, and ever expands 
        the network that feeds so much of today’s pop-culture."),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      
      h2("Twitter: B.Y.O.C. (Bring Your Own (Pop)Culture) "),
      p("Due to the nature of Twitter’s open architecture, a great benefit of this platform is the ability to 
        “bring-your-own” culture, which includes, bringing your favorite type of ",
        em("pop-culture"), 
        "to your feed. Each user’s Twitter context is self-developed; users curate their own community on the site. By following friends, 
        strangers, celebrities, or hashtags, users are able to bring their (pop)culture to the table and develop their 
        unique social graphs."),
      br(),
      img(src = 'followme.png', align = "right", height = 280, width = 600),
      p(strong("Topics of Interest:")),
      p("- How are our screens fueled by public figures, and how are public figures fueled by our screens?"),
      p("- How does the topic of sports go beyond the court, field, and arena, and into the world of twitter?"),
      p("- Which trending topics are able to transcend national borders, and which are defined by the country itself?"),
      p("- How and when does the influence of television bring rise to a community of twitter users?"),
      br(),
      #img(src = 'followme.png', align = "right", height = 200, width = 600),

      
      img(src = 'map.jpg', align = "right", height = 200, width = 350),
      h2("Want to Join the Fun?"),
      p("Click here to ",
        a("create your own Twitter account!", 
          href = "https://twitter.com/?lang=en")),
      p("Get involved with the easy, low-maintenance platform to keep up with the latest social trends, 
        breaking news, celebrity gossip and industry developments. See what all the hype is about!"),
      br(),

      
      h2("Our Data"),
      p("For this project, we used data from Twitter's very own API key. The data accesses tweets from Twitter's
        public users over the past month, and contains information about the content of the tweet, the time it was posted, 
        number of retweets, number of favorites, what device it was made on, and the number of followers a user has.")
      
    )
  )
)

