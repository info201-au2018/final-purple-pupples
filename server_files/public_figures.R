library(twitteR)
library(RCurl)
library(tm)
library(wordcloud)
library(dplyr)
library(jsonlite)


word_cloud_message <- function(input) {
  if (input$public_figure != "") {
    message <- paste("This word cloud shows you the most commonly used words associated with", input$public_figure, "
                   in the last", input$num_of_tweets, "tweets that contain his/her name.")
  #return(message)
  } else {
      message <- paste("Please search for a public figure.")
  }
}


word_cloud <- function(input) {
  #searching for a public figure and getting n amount of tweets
  if (input$public_figure != "") {
    public_figure <- searchTwitter(input$public_figure, lang = "en", n = input$num_of_tweets, resultType = "recent")
    public_figure_text <- sapply(public_figure, function(x) x$getText())
    #turn into corpus
    public_figure_corpus <- Corpus(VectorSource(public_figure_text))
    public_figure_clean <- tm_map(public_figure_corpus, removePunctuation) %>%
      tm_map(content_transformer(tolower)) %>%
      tm_map(removeWords, stopwords("english")) %>%
      tm_map(removeNumbers) %>%
      tm_map(stripWhitespace)
    word_cloud_final <- wordcloud(public_figure_clean, random.order = F,
                                  scale = c(4, 1), colors = rainbow(50), max.words = 100)
    return(word_cloud_final)
  }
}

compare_users <- function(input) {
  user1 <- getUser(input$user1)
  user2 <- getUser(input$user2)
}


