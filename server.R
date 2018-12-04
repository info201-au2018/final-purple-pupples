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
  output$TV_times <- renderPlot({
    plots
  })
  data <- reactive ({
    bar <- bar_plot
    if (input$radio2 == "computer") {
     if (input$radio == "Retweets") {
       bar <- bar_plot2
     } else {
       bar <- bar_plot3
     }
    }
    if (input$radio2 == "phone/tablet") {
      if (input$radio == "Retweets") {
        bar <- bar_plot2
      } else {
      bar <- bar_plot4
      }
    }
    bar
  })
  
  output$favorites <- renderPlot({
    data()
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