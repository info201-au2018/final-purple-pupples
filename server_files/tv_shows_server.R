library(dplyr)
library(data.table)
library(tidyr)
library(ggplot2)
library(ggthemes)
theme_set(theme_classic())
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

#SNL
#tw_SNL = twitteR::searchTwitter('#SNL', n = 1000, since = '2018-12-01', until = '2018-12-02', retryOnRateLimit = 1e3)
#SNL = twitteR::twListToDF(tw_SNL)

#CATFISH
#tw_catfish = twitteR::searchTwitter('#Catfish', n = 1500, since = '2018-11-28', until = '2018-11-29', retryOnRateLimit = 1e3)
#catfish = twitteR::twListToDF(tw_catfish)

#write.csv(kard, file = "kardashians_hashtag.csv", row.names = FALSE)
#write.csv(ahs, file = "ahs_hashtag.csv", row.names = FALSE)
#write.csv(voice, file = "thevoice_hashtag.csv", row.names = FALSE)
#write.csv(catfish, file = "catfish_hashtag.csv", row.names = FALSE)
#write.csv(SNL, file = "SNL_hashtag.csv", row.names = FALSE)

kardashians <- read.csv("csv_files/kardashians_hashtag.csv")
american_hs <- read.csv("csv_files/ahs_hashtagcopy.csv")
the_voice <- read.csv("csv_files/thevoice_hashtagcopy.csv")
#catfish <- read.csv("csv_files/catfish_hashtag.csv")
snl <- read.csv("csv_files/SNL_hashtag.csv")

#FILTERING
filter_useful <- function(table) {
  useful <- select(table, text, favoriteCount, replyToSN, created, id, screenName, retweetCount, statusSource) %>%
    separate(created, c("date", "time"), sep = '\\s', remove = TRUE) %>%
    mutate(time = substr(time, 1, 2)) 
}

kardashians_filtered <- filter_useful(kardashians)
ahs_filtered <- filter_useful(american_hs)
voice_filtered <- filter_useful(the_voice)
#catfish_filtered <- filter_useful(catfish)
snl_filtered <- filter_useful(snl)

kardashians_filtered$statusSource <- ifelse(grepl("Web", kardashians_filtered$statusSource), "computer", "phone/tablet")
ahs_filtered$statusSource <- ifelse(grepl("Web", ahs_filtered$statusSource), "computer", "phone/tablet")
voice_filtered$statusSource <- ifelse(grepl("Web", voice_filtered$statusSource), "computer", "phone/tablet")
#catfish_filtered$statusSource <- ifelse(grepl("Web", catfish_filtered$statusSource), "computer", "phone/tablet")
snl_filtered$statusSource <-ifelse(grepl("Web", snl_filtered$statusSource), "computer", "phone/tablet")

get_tweet_times <- function(data) {
  show_time <- select(data, text, favoriteCount, date, time, retweetCount) %>%
    group_by(time) %>% summarize(count = n())
  return (show_time)
}

##GRAPHS
kardashians_data <- get_tweet_times(kardashians_filtered)
ahs_data <- get_tweet_times(ahs_filtered)
voice_data <- get_tweet_times(voice_filtered)
#catfish_data <- get_tweet_times(catfish_filtered)
snl_data <- get_tweet_times(snl_filtered)

#GETTING DEVICE
kardashians_computer <- filter(kardashians_filtered, statusSource == "computer") %>%
                        get_tweet_times()
kardashians_device <- filter(kardashians_filtered, statusSource == "phone/tablet") %>%
                      get_tweet_times()
ahs_computer <- filter(ahs_filtered, statusSource == "computer") %>%
                get_tweet_times()
ahs_device <- filter(ahs_filtered, statusSource == "phone/tablet") %>%
              get_tweet_times()
voice_computer <- filter(voice_filtered, statusSource == "computer") %>%
                  get_tweet_times()
voice_device <- filter(voice_filtered, statusSource == "phone/tablet") %>%
                get_tweet_times()
snl_computer <- filter(snl_filtered, statusSource == "computer") %>%
                get_tweet_times()
snl_device <- filter(snl_filtered, statusSource == "phone/tablet") %>%
              get_tweet_times()
#Tweets 
plots <- ggplot() +
  geom_line(aes(x = time, y = count, color = "Keeping Up With the Kardashians: Airs 21:00 PM PT", group = 1), data = kardashians_data, stat = "identity") +
  geom_line(aes(x = time, y = count, color = "American Horror Story: Airs 19:00 PM PT", group = 1), data = ahs_data, stat = "identity") +
  geom_line(aes(x = time, y = count, color = "The Voice: Airs 20:00 PM PT", group = 1), data = voice_data, stat = "identity") +
  geom_line(aes(x = time, y = count, color = "SNL: Airs 20:30 PM PT", group = 1), data = snl_data, stat = "identity") +
  xlab("Time (PT)") + ylab("Number of Tweets") + ylim(0, 250)

plots_comp <- ggplot() +
  geom_line(aes(x = time, y = count, color = "Keeping Up With the Kardashians: Airs 21:00 PM PT", group = 1), data = kardashians_computer, stat = "identity") +
  geom_line(aes(x = time, y = count, color = "American Horror Story: Airs 19:00 PM PT", group = 1), data = ahs_computer, stat = "identity") +
  geom_line(aes(x = time, y = count, color = "The Voice: Airs 20:00 PM PT", group = 1), data = voice_computer, stat = "identity") +
  geom_line(aes(x = time, y = count, color = "SNL: Airs 20:30 PM PT", group = 1), data = snl_computer, stat = "identity") +
  xlab("Time (PT)") + ylab("Number of Tweets") + ylim(0, 250)

plots_dev <- ggplot() +
  geom_line(aes(x = time, y = count, color = "Keeping Up With the Kardashians: Airs 21:00 PM PT", group = 1), data = kardashians_device, stat = "identity") +
  geom_line(aes(x = time, y = count, color = "American Horror Story: Airs 19:00 PM PT", group = 1), data = ahs_device, stat = "identity") +
  geom_line(aes(x = time, y = count, color = "The Voice: Airs 20:00 PM PT", group = 1), data = voice_device, stat = "identity") +
  geom_line(aes(x = time, y = count, color = "SNL: Airs 20:30 PM PT", group = 1), data = snl_device, stat = "identity") +
  xlab("Time (PT)") + ylab("Number of Tweets") + ylim(0, 250)
#Favorites
get_favorites <- function(data) {
  favorites <- select(data, favoriteCount, time) %>%
    group_by(time) %>% summarize(Favorites = sum(favoriteCount))
}

kardash_fav <- get_favorites(kardashians_filtered)
ahs_fav <- get_favorites(ahs_filtered)
voice_fav <- get_favorites(voice_filtered)
snl_fav <- get_favorites(snl_filtered)

favs_plot_kardash <- ggplot() + 
  geom_histogram(mapping = aes(x = time, y = Favorites, fill = "Kardashians"), stat = "identity", 
                 data = kardash_fav, binwidth = 0.1) + coord_flip() + ylim(0, 2000) +
  scale_fill_manual("Show", values = c("olivedrab")) + labs(title = "Favorites vs Time of Day",
                                                            x = "Number of Favorites", 
                                                            y = "Time (PT)")

favs_plot_ahs <- ggplot() + 
  geom_histogram(mapping = aes(x = time, y = Favorites, fill = "American Horror Story"), stat = "identity", 
                 data = ahs_fav, binwidth = 0.1) + coord_flip() + ylim(0, 2000)  +
  scale_fill_manual("Show", values = c("salmon")) + labs(title = "Favorites vs Time of Day",
                                                         x = "Number of Favorites", 
                                                         y = "Time (PT)")

favs_plot_voice <- ggplot() + 
  geom_histogram(mapping = aes(x = time, y = Favorites, fill = "The Voice"), stat = "identity", 
                 data = voice_fav, binwidth = 0.1) + coord_flip() + ylim(0, 2000) +
  scale_fill_manual("Show", values = c("mediumorchid1")) + labs(title = "Favorites vs Time of Day",
                                                        x = "Number of Favorites", 
                                                        y = "Time (PT)")

favs_plot_snl <- ggplot() + 
  geom_histogram(mapping = aes(x = time, y = Favorites, fill = "SNL"), stat = "identity", 
                 data = snl_fav, binwidth = 0.1) + coord_flip() + ylim(0, 2000)  +
  scale_fill_manual("Show", values = c("cyan3")) + labs(title = "Favorites vs Time of Day",
                                                                x = "Number of Favorites", 
                                                                y = "Time (PT)")

favorites_plot <- ggplot() + 
          geom_histogram(mapping = aes(x = time, y = Favorites, fill = "Kardashians"), stat = "identity", data = kardash_fav,
                         alpha = 0.5, binwidth = 0.1) +
          geom_histogram(mapping = aes(x = time, y = Favorites, fill = "AHS"), stat = "identity", data = ahs_fav,
                         alpha = 0.5, binwidth = 0.1) +
          geom_histogram(mapping = aes(x = time, y = Favorites, fill = "TheVoice"), stat = "identity", data = voice_fav,
                         alpha = 0.5, binwidth = 0.1) +
          geom_histogram(mapping = aes(x = time, y = Favorites, fill = "SNL"), stat = "identity", data = snl_fav,
                 alpha = 0.5, binwidth = 0.1) + coord_flip() + labs(title = "Favorites vs Time of Day",
                                                                    x = "Number of Favorites", 
                                                                    y = "Time (PT)") + ylim(0, 2000) 

#Retweets
get_retweets <- function(data) {
  retweets <- select(data, retweetCount, time) %>%
              group_by(time) %>% summarize(Retweets = sum(retweetCount))
}

kardash_ret <- get_retweets(kardashians_filtered)
ahs_ret <- get_retweets(ahs_filtered)
voice_ret <- get_retweets(voice_filtered)
snl_ret <- get_retweets(snl_filtered)

retweets_plot_kardash <- ggplot() + 
  geom_histogram(mapping = aes(x = time, y = Retweets, fill = "Kardashians"), stat = "identity", 
                 data = kardash_ret, binwidth = 0.1) + coord_flip() + ylim(0, 20000) +
                 scale_fill_manual("Show", values = c("olivedrab")) + labs(title = "Retweets vs Time of Day",
                                                                           x = "Time (PT)", 
                                                                           y = "Number of Retweets")

retweets_plot_ahs <- ggplot() + 
  geom_histogram(mapping = aes(x = time, y = Retweets, fill = "American Horror Story"), stat = "identity", 
                 data = ahs_ret, binwidth = 0.1) + coord_flip() + ylim(0, 20000) +
  scale_fill_manual("Show", values = c("salmon")) + labs(title = "Retweets vs Time of Day",
                                                         x = "Time (PT)", 
                                                         y = "Number of Retweets")

retweets_plot_voice <- ggplot() + 
  geom_histogram(mapping = aes(x = time, y = Retweets, fill = "The Voice"), stat = "identity", 
                 data = voice_ret, binwidth = 0.1) + coord_flip() + ylim(0, 20000) +
  scale_fill_manual("Show", values = c("mediumorchid1")) + labs(title = "Retweets vs Time of Day",
                                                                x = "Time (PT)", 
                                                                y = "Number of Retweets")

retweets_plot_snl <- ggplot() + 
  geom_histogram(mapping = aes(x = time, y = Retweets, fill = "SNL"), stat = "identity", 
                 data = snl_ret, binwidth = 0.1) + coord_flip() + ylim(0, 20000)  +
  scale_fill_manual("Show", values = c("cyan3")) + labs(title = "Retweets vs Time of Day",
                                                        x = "Time (PT)", 
                                                        y = "Number of Retweets")
gg <- ggplot() +
  geom_histogram(mapping = aes(x = time, y = Retweets, fill = "Kardashians"), stat = "identity", 
                 alpha = 0.5, data = kardash_ret, binwidth = 0.1) + 
  geom_histogram(mapping = aes(x = time, y = Retweets, fill = "American Horror Story"), stat = "identity", 
                 alpha = 0.5, data = ahs_ret, binwidth = 0.1) +
  geom_histogram(mapping = aes(x = time, y = Retweets, fill = "The Voice"), stat = "identity", 
                 alpha = 0.5, data = voice_ret, binwidth = 0.1) + 
  geom_histogram(mapping = aes(x = time, y = Retweets, fill = "SNL"), stat = "identity", 
                 alpha = 0.5, data = snl_ret, binwidth = 0.1) + ylim(0, 20000) + coord_flip() +
  labs(title = "Retweets vs Time of Day",
         x = "Time (PT)", 
         y = "Number of Retweets")
  
#####
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
