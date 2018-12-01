source("./server_files/tv_shows_server.R")
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
}

shinyServer(my_server)