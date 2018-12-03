##This will be the server side of the sports tab
library(httr)
library(twitteR)
library(jsonlite)
library(dplyr)
library(stringr)
library(ggplot2)
library(directlabels)
library(grid)
library(lubridate)
#I will also be using data from sportrader Api to 
#compare twitter data against scores and odds from the games
source("twitter_keys.R")

##Given a Team Name and a Week of the 2018 NFL season will return the GameID for 
##the specified parameters
GetGameID <- function(teamName, week) {
  print(teamName)
  nfl_uri <- paste0("https://api.sportradar.us/nfl/official/trial/v5/en/games/2018/REG/",week,
                    "/schedule.json?api_key=", nfl_key);
  response <- GET(nfl_uri)
  body <- httr::content(response, "text")
  results <- fromJSON(body)
  games_df <- results$week$games
  
  temp <- flatten(games_df)
  
  user_input <- paste0("(?i)", teamName)
  row_identifier <- str_detect(temp$away.name, user_input) | str_detect(temp$home.name, user_input)
  temp %>% filter(row_identifier) %>% select(id)
}

##Given a GameID will return the scores of a game and time formatted into a dataFrame
GetBoxScore <- function(game_id){
  nfl_uri <- paste0("https://api.sportradar.us/nfl/official/trial/v5/en/games/",
                    game_id, "/boxscore.json?api_key=",nfl_key)
  response <- GET(nfl_uri)
  body <- httr::content(response, "text")
  results <- fromJSON(body)
  
  record_of_scoring <- results$scoring_plays %>% select(home = home_points,
                                                        away = away_points, clock, time = wall_clock)
  record_of_scoring$quarter <- results$scoring_plays$quarter$number
  record_of_scoring$scheduled <- results$scheduled
  record_of_scoring$offset <- results$utc_offset
  record_of_scoring$home_name <- results$summary$home$name
  record_of_scoring$away_name <- results$summary$away$name
  return (record_of_scoring)
  
}

##Returns a 2 column frame with 10 minute interval and the number of tweets
GetTweetsAboutGame <- function(team_name, date_p, score_df){
  #Create date and time bounds
  date <- as.Date(ExtractDate(date_p))
  bounds <- c(date - 1, date + 1)
  time <- ExtractTime(date_p)
  time_bounds <- c(st_time = AddTime(time, score_df$offset[1]), 
                                     end_time = AddTime(time, score_df$offset[1] + 3))
  
  #Scrape twitter for all tweets during the given day interval
  results <- tryCatch({
    suppressWarnings(twitteR::searchTwitter(paste0("#", team_name), n = 10000, since = as.character(date - 1), 
                                             until = as.character(date + 1), retryOnRateLimit = 1e3, lang = "en"))
  },
  error = function(cond) {
    message(cond)
    
  },
  warning = function(cond) {
    message(cond)
  }, finally = {
    twitteR::searchTwitter(paste0("#", team_name), n = 7000, since = as.character(date - 1), 
                                                until = as.character(date + 1), retryOnRateLimit = 1e3, lang = "en")
  })

  tweets <- twitteR::twListToDF(results)
  
  #Extract tweets that only fall in given interval
  tweets$created <- as.character(tweets$created)
  game_tweets <- tweets %>% filter(created >= paste(date, time_bounds[1]) &
                                     created < paste(date, time_bounds[2]))
  if (nrow(game_tweets) == 0) {
    return("Sorry this game was so popular there are too many tweets for our basic api subscription 
           to handle it")
    break
  } 
  
  #Group Tweets by 10 min interval
  t <- ceiling(3 / count(score_df) * 60) 
  adjust_max <- ymd_hms(max(game_tweets$created)) + 60 * t$n
  interval <- seq(ymd_hms(min(game_tweets$created)), adjust_max, by = paste(t, "min"))
  game_tweets$created <- ymd_hms(game_tweets$created)
  game_tweets$interval <- cut(game_tweets$created, interval)
  tweet_count <- game_tweets %>% group_by(interval) %>% summarise(n = n()) %>% filter(!is.na(interval))
}

##Extracts Date from the format yy/mm/ddT
ExtractDate <- function(t) {
  date_time <- strsplit(t, "T")
  date <- date_time[[1]][1]
}

ExtractTime <- function(t) {
  date_time <- strsplit(t, "T")
  time <- strsplit(date_time[[1]][2], "\\+")
  result <- time[[1]][1]
}

AddTime <- function(t, num) {
  temp <- strsplit(t, ":")
  hour <- as.integer(temp[[1]][1])
  new_hour <- hour + num
  result <- paste(new_hour,temp[[1]][2],temp[[1]][2], sep = ":")
  
}

FormatTime <- function(t) {
  paste(hour(t), minute(t), second(t), sep=":")
}

TweetScorePlot <- function(name, week) {
  
  id <- GetGameID(name, week)
  print(id)
  Sys.sleep(3) #Have to do this due to restrictions on API key
  
  score_df <- GetBoxScore(id)
  preload <- GetPreload(score_df$home_name[1], score_df$away_name[1], week)
  t_count <- GetTweetsAboutGame(name, score_df$scheduled, score_df)
  if (is.character(t_count)) {
    return(t_count)
    break
  }
  t_count$formatted <- FormatTime(t_count$interval)
  t_count$label <- "TWEETS"
  score_df$formatted <- FormatTime(ymd_hms(score_df$time))
  score_df$formatted <- hms(score_df$formatted)
  hours <- hour(score_df$formatted) + score_df$offset
  hours <- ifelse(hours < 0, 24 + hours, hours)
  score_df$formatted <- hms(paste(hours, minute(score_df$formatted),
                                  second(score_df$formatted), sep = ":"))
  score_df$formatted <- FillNAs(score_df$formatted)
  home_score <- select(score_df, home, formatted)
  away_score <- select(score_df, away, formatted)
  t_count <- select(t_count, num_tweets = n, formatted, label)
  t_count$formatted <- t_count$formatted %>% hms()
  t_count$score <- NA
  home_score$label <- as.character(score_df$home_name[1]) #Replace with team names
  away_score$label <- as.character(score_df$away_name[1]) #Replce with team names
  names(home_score)[1] <- "score"
  names(away_score)[1] <- "score"
  scores <- rbind(home_score, away_score)
  scores$num_tweets <- NA
  scores <- rbind(scores, t_count)
  scores$formatted <- unlist(scores$formatted)
  write.csv(scores, paste0("./csv_files/", home_score$label[1],"_",away_score$label[1],"_",week,".csv"), row.names = FALSE)
  x_axis <- round(seq(0, 360, by = 360 / nrow(scores)))
  ggplot() + geom_line(data = away_score, aes(x = as.numeric(formatted), y = score, group = 1, color = label)) +
    geom_line(data = home_score, aes(x = as.numeric(formatted), y = score, group = 1, color = label)) + 
    geom_line(data = t_count, aes(x = as.numeric(formatted), y = num_tweets, group = 1, color = label)) + 
    scale_y_continuous(sec.axis = sec_axis(~.*1, name = "Tweets")) + 
    scale_x_discrete(labels = x_axis) + theme(axis.text.x=element_text(colour="blue",size=10)) +
    labs(title = "Scores vs Tweets", x = "Elapsed Time (minutes)", y = "Score")
  
}

FillNAs <- function(q) {
  count <- 1
  r <- c()
  for (i in q) {
    if(is.na(i)) {
      r <- c(r, count)
    }
    count <- count + 1
  }  
  q[r] <- hms(paste(floor((hour(q[r + 1]) + hour(q[r - 1])) / 2), 
                floor((60 - minute(q[r + 1]) + minute(q[r - 1])) /2), 
                floor((60 - second(q[r + 1]) + second(q[r - 1]))/2)))
  return(q)
  
}

GetPreload <- function(h_name, a_name, week) {
  preload <- read.csv(paste0("./csv_files/", h_name,"_", a_name, "_", week, ".csv"))
}


#TODO: Seperate tweets into to two groups one containing home team mention, other with away team mentions
#TODO: Create plot overlaying scores and # of mentions for each time
#TODO: Abstract out to any sport? i.e ncaa football, squash, curling...

#TODO: What other visualizations can you do?