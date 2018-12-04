library(dplyr)
library(data.table)
library(tidyr)
library(ggplot2)
library(ggthemes)
#GETTING DATA

#KARDASHIANS
#tw = twitteR::searchTwitter('#KUWTK', n = 10000, since = '2018-11-25', until = '2018-11-26', retryOnRateLimit = 1e3)
#kard = twitteR::twListToDF(tw)

#AHS
#tw_ahs = twitteR::searchTwitter('#AHS', n = 1000, since = '2018-11-21', until = '2018-11-22', retryOnRateLimit = 1e3)
#ahs = twitteR::twListToDF(tw_ahs)

#THEVOICE
#tw_the_voice = twitteR::searchTwitter('#TheVoice', n = 1000, since = '2018-11-20', until = '2018-11-21', retryOnRateLimit = 1e3)
#voice = twitteR::twListToDF(tw_the_voice)
#View(f)

#FRESHOFFTHEBOAT
#tw_challenge = twitteR::searchTwitter('#Greys', n = 1000, since = '2018-11-15', until = '2018-11-16', retryOnRateLimit = 1e3)
#fresh = twitteR::twListToDF(tw_riverdale)

#write.csv(kard, file = "kardashians_hashtag.csv", row.names = FALSE)
#write.csv(ahs, file = "ahs_hashtag.csv", row.names = FALSE)
#write.csv(voice, file = "thevoice_hashtag.csv", row.names = FALSE)

kardashians <- read.csv("csv_files/kardashians_hashtag.csv")
american_hs <- read.csv("csv_files/ahs_hashtagcopy.csv")
the_voice <- read.csv("csv_files/thevoice_hashtagcopy.csv")


#FILTERING
filter_useful <- function(table) {
  useful <- select(table, text, favoriteCount, replyToSN, created, id, screenName, retweetCount, statusSource) %>%
            separate(created, c("date", "time"), sep = '\\s', remove = TRUE) %>%
            mutate(time = substr(time, 1, 2)) 
}

kardashians_filtered <- filter_useful(kardashians)
ahs_filtered <- filter_useful(american_hs)
voice_filtered <- filter_useful(the_voice)

kardashians_filtered$statusSource <- ifelse(grepl("Web", kardashians_filtered$statusSource), "computer", "phone/tablet")
ahs_filtered$statusSource <- ifelse(grepl("Web", ahs_filtered$statusSource), "computer", "phone/tablet")
voice_filtered$statusSource <- ifelse(grepl("Web", voice_filtered$statusSource), "computer", "phone/tablet")

get_tweet_times <- function(data) {
  show_time <- select(data, text, favoriteCount, date, time, retweetCount) %>%
                group_by(time) %>% summarize(count = n())
  return (show_time)
}

##GRAPHS
kardashians_data <- get_tweet_times(kardashians_filtered)
ahs_data <- get_tweet_times(ahs_filtered)
voice_data <- get_tweet_times(voice_filtered)

    plots <- ggplot() +
      geom_line(aes(x = time, y = count, color = "Keeping Up With the Kardashians: Airs 21:00 PM PT", group = 1), data = kardashians_data, stat = "identity") +
      geom_line(aes(x = time, y = count, color = "American Horror Story: Airs 19:00 PM PT", group = 1), data = ahs_data, stat = "identity") +
      geom_line(aes(x = time, y = count, color = "The Voice: Airs 20:00 PM PT", group = 1), data = voice_data, stat = "identity") +
      xlab("Time (PT)") + ylab("# of Tweets")

    favorites <- select(kardashians_filtered, favoriteCount, time) %>%
                group_by(favoriteCount, time) %>% summarize(count = n())
    retweets <- select(kardashians_filtered, retweetCount, time) %>%
                group_by(retweetCount, time) %>% summarize(count = n())
    
    theme_set(theme_tufte())
    bar_plot <- ggplot(favorites, aes(x = time, y = count), height = 1227, width = 607) +
    geom_tufteboxplot() + theme(axis.text.x = element_text(angle=65, vjust=0.6)) +
    xlab("Time") + ylab("# of Favorites") + 
    labs(title = "# of Occurences of Favorites/Time of Day") 
    
    bar_plot2 <- ggplot(retweets, aes(x = time, y = count), height = 1227, width = 607) +
                geom_tufteboxplot() + theme(axis.text.x = element_text(angle=65, vjust=0.6)) +
                xlab("Time") + ylab("# of Retweets") + 
                labs(title = "# of Occurences of Retweets/Time of Day")
 
    favorites_computer <- filter(kardashians_filtered, statusSource == "computer") %>%
                          select(favoriteCount, time) %>%
                          group_by(favoriteCount, time) %>% summarize(count = n())
    
    favorites_phone <-  filter(kardashians_filtered, statusSource == "phone/tablet") %>%
                        select(favoriteCount, time) %>%
                        group_by(favoriteCount, time) %>% summarize(count = n())
    
    theme_set(theme_tufte())
    bar_plot3 <- ggplot(favorites_computer, aes(x = time, y = count), height = 1227, width = 607) +
      geom_tufteboxplot() + theme(axis.text.x = element_text(angle=65, vjust=0.6)) +
      xlab("Time") + ylab("# of Favorites") + 
      labs(title = "# of Occurences of Favorites/Time of Day")
    
    bar_plot4 <- ggplot(favorites_phone, aes(x = time, y = count), height = 1227, width = 607) +
      geom_tufteboxplot() + theme(axis.text.x = element_text(angle=65, vjust=0.6)) +
      xlab("Time") + ylab("# of Favorites") + 
      labs(title = "# of Occurences of Favorites/Time of Day")

    
    ##TOP 3 TWEETS
    
    get_tweets<- function(hashtag) {
    tweets <- searchTwitter(hashtag, lang = "en", n = 1000, resultType = "recent")
    tweets <- twListToDF(tweets)
    }
    
    get_top_tweets <- function(table) {
      top_tweets <- arrange(table, -retweetCount) %>%
        distinct(text, retweetCount) %>%
        head(3)
      return (top_tweets)
    }
    
  kardashian_tweets <- get_top_tweets(kardashians_filtered)
  ahs_tweets <- get_top_tweets(ahs_filtered)
  voice_tweets <- get_top_tweets(voice_filtered)


#kardashians <- get_tv_tweets('#KUWTK')
#AHS <- get_tv_tweets('#AHS') 
#the_voice <- get_tv_tweets("#TheVoice")
