source("./server_files/tv_shows_server.R")
source("./server_files/public_figures.R")
source("./server_files/Trending.R")

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


  output$word_cloud_text <- renderText(
    word_cloud_message(input)
  )
  output$public_figure_word_cloud <- renderPlot({
    word_cloud(input)
  }, width = 800, height = 600)
  
  # #kaitlyn
  dt_data <- reactive({
      kc_data <- all_country_data
      #print(input$country)
      if (input$country != "All") {
        kc_data <- filter(kc_data, country == input$country)
      }
      
      if (input$link != "All") {
        kc_data <- filter[kc_data, url == input$link]
      }
      #print(input$country)
      
      if (input$trend != "All") {
         kc_data <- filter[kc_data, trend == input$trend,]
      }
      kc_data
    })
    output$table <- DT::renderDataTable({
      print(input$country)
      dt_data()})
  # output$table <- DT::renderDataTable(DT::datatable({
  #   data <- all_country_data
  #   if (input$country != "All") {
  #     data <- data[data$country == input$country,]
  #   }
  #   if (input$trend != "All") {
  #     data <- data[data$trend == input$trend,]
  #   }
  #   if (input$url != "All") {
  #     data <- data[data$url == input$url,]
  #   }
  #   data
  # }))
    
  }

# kaitlyn 
# output$table <- DT::renderDT(DT::datatable(dt_data()))
#kc_data <- kc_data[kc_data$country == input$country,]
shinyServer(my_server)