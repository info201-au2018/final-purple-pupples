source("./server_files/tv_shows_server.R")
source("./server_files/public_figures.R")

my_server <- function(input, output) {
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
  output$word_cloud_text <- renderText(
    word_cloud_message(input)
  )
  output$public_figure_word_cloud <- renderPlot({
    word_cloud(input)
  }, width = 800, height = 600)
  
  
  
}