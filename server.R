source("./server_files/tv_shows_server.R")
source("./server_files/public_figures.R")

my_server <- function(input, output){
  getTable <- reactive({
    table <- kardashian_tweets
    if(input$text != "") {
    table <- get_tweets(input$text)
    table <- get_top_tweets(table)
   }
    table
  })
  get_tweets <- reactive ({
    tweets_graph <- plots
    if(input$select2 == "Computer") {
      tweets_graph <- plots_comp
    }
    if(input$select2 == "Phone/Ipad") {
      tweets_graph <- plots_dev
    }
    tweets_graph
  })
  getPlot <- reactive ({
    plot <- gg
    if(input$select == "Retweets") {
      if(input$tvshow == "Keeping up with the Kardashians") {
        plot <- retweets_plot_kardash
      } 
      if (input$tvshow == "American Horror Story") {
        plot <- retweets_plot_ahs
      }
      if (input$tvshow == "The Voice") {
        plot <- retweets_plot_voice
      }
      if (input$tvshow == "Saturday Night Live") {
        plot <- retweets_plot_snl
      }
    }
     if(input$select == "Favorites") {
        plot <- favorites_plot
        if(input$tvshow == "Keeping up with the Kardashians") {
          plot <- favs_plot_kardash
        } 
        if (input$tvshow == "American Horror Story") {
          plot <- favs_plot_ahs
        }
        if (input$tvshow == "The Voice") {
          plot <- favs_plot_voice
        }
        if (input$tvshow == "Saturday Night Live") {
          plot <- favs_plot_snl
        }
    }
    plot
  })
  output$TV_times <- renderPlot({
    get_tweets()
  })
  output$fav <- renderPlot({
    getPlot()
  })
  output$tweetTable <- renderDataTable({getTable()})
  output$word_cloud_text <- renderText({
    word_cloud_message(input)
  })
  
  output$public_figure_word_cloud <- renderPlot({
    word_cloud(input)
  }, width = 1000, height = 800)
  
  output$user1_image <- renderUI({
    tags$img(src = user1_image_url(input), height = 75,
             width = 75)
  })
  output$user2_image <- renderUI({
    tags$img(src = user2_image_url(input), height = 75, 
             width = 75)
  })
  
  output$compare_users_table <- renderTable(
    description_table(input)
  )
  
  public_figures_plot <- reactive ({
    figuresplot <- bar_graph_tweets(input)
    if (input$checks == "followersCount") {
      figuresplot <- bar_graph_followers(input)
    }
    figuresplot
  })
  
  output$compare_users_graph <- renderPlot({
   public_figures_plot()}, width = 800, height = 800)


  output$data_table_description <- renderText({
    table_description(input)
  })
  
}


shinyServer(my_server)

