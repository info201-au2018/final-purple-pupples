library(twitteR)
library(RCurl)
library(tm)
library(wordcloud)
library(dplyr)
library(data.table)


word_cloud_message <- function(input) {
    message <- paste("This word cloud shows you the most commonly used words associated with", input$public_figure, "
                   in the last", input$num_of_tweets, "tweets that contain his/her name.")
  return(message)
}


word_cloud <- function(input) {
  #searching for a public figure and getting n amount of tweets
    public_figure <- searchTwitter(input$public_figure, lang = "en", n = input$num_of_tweets, resultType = "recent")
    public_figure_text <- sapply(public_figure, function(x) x$getText())
    #turn into corpus
    public_figure_corpus <- Corpus(VectorSource(public_figure_text))
    public_figure_clean <- tm_map(public_figure_corpus, removePunctuation) %>%
      tm_map(content_transformer(tolower)) %>%
      tm_map(removeWords, stopwords("english")) %>%
      tm_map(removeNumbers) %>%
      tm_map(stripWhitespace)
    pal <- brewer.pal(9, "PuBu")
    pal <- pal[-(1:5)]
    word_cloud_final <- wordcloud(public_figure_clean, random.order = F,
                                  scale = c(4, 1), color = pal, max.words = 100)
    return(word_cloud_final)
}
  
description_table <- function(input) {
  user1 <- getUser(input$user1)
  user2 <- getUser(input$user2)
  twitter_handle <- c(input$user1, input$user2)
  names <- c(user1$name, user2$name)
  description <- c(user1$description, user2$description)
  verified <- c(user1$verified, user2$verified)
  recent_tweet <- c(user1$lastStatus$text, user2$lastStatus$text)
  plot <- data.table(twitter_handle, names, description, verified, recent_tweet, stringsAsFactors = FALSE)
  plot <- setNames(plot, c("Twitter Username", "Name", "User Description", "Verified User?", "Latest Tweet"))
}

table_description <- function(input) {
  message <- paste("This data table displays a picture of each Twitter user in addition to their twitter username,
                   a description of who they are, whether or not they are verified, and thier latest tweet.")
  return(message)
}


bar_graph_tweets <- function(input) {
  #type <- "statusesCount"
  user1 <- getUser(input$user1)
  user2 <- getUser(input$user2)
  user1_name <- user1$name
  user2_name <- user2$name
  names <- c(user1_name, user2_name)
  user1_type <- user1$statusesCount
  user2_type <- user2$statusesCount
  list <- c(user1_type, user2_type)
  table <- data.table(names, list)
  counts <- table$list
  pal <- brewer.pal(9, "PuBu")
  pal <- pal[-(1:2)]
  plot <- barplot(counts, main = paste("Comparing # of Tweets between", user1_name, "and", user2_name),
                     xlab = "Twitter User", names.arg = c(user1_name, user2_name), ylab = "# of Tweets",
                  col = pal)
  text(x = plot, y = counts, label = counts, pos = 3, cex = 1.5, col = "blue")
  
  return(plot)
}

bar_graph_followers <- function(input) {
  #type <- "followersCount"
  user1 <- getUser(input$user1)
  user2 <- getUser(input$user2)
  user1_name <- user1$name
  user2_name <- user2$name
  names <- c(user1_name, user2_name)
  user1_type <- user1$followersCount
  user2_type <- user2$followersCount
  list <- c(user1_type, user2_type)
  table <- data.table(names, list)
  counts <- table$list
  pal <- brewer.pal(9, "PuBu")
  pal <- pal[-(1:2)]
  plot <- barplot(counts, main = paste("Comparing # of Followers between", user1_name, "and", user2_name),
                  xlab = "Twitter User", names.arg = c(user1_name, user2_name), ylab = "# of Followers",
                  col = pal)
  text(x = plot, y = counts, label = counts, pos = 3, cex = 1.5, col = "blue")
  return(plot)
  
}

user1_image_url <- function(input) {
  user1 <- getUser(input$user1)
  user1_url <- user1$profileImageUrl
  return(user1_url)
}

user2_image_url <- function(input) {
  user2 <- getUser(input$user2)
  user2_url <- user2$profileImageUrl
  return(user2_url)
}



