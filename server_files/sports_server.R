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
theme_set(theme_classic())
#I will also be using data from sportrader Api to 
#compare twitter data against scores and odds from the games
source("twitter_keys.R")

####################################
##Give a Name and a Week get an ID##
####################################

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

######################
##Retrieve Box Score##
######################

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

###########################################################
####Function that retrieves Tweets about a specific game###
###########################################################

GetTweetsAboutGame <- function(team_name, date_p, score_df){
  #Create date and time bounds
  date <- as.Date(ExtractDate(date_p))
  bounds <- c(date - 1, date + 1)
  time <- ExtractTime(date_p)
  time_bounds <- c(st_time = AddTime(time, score_df$offset[1]), 
                                     end_time = AddTime(time, score_df$offset[1] + 3))
  
  #Scrape twitter for all tweets during the given day interval, tries 100000 tweets
  #But if there are not enough will try again at 7000 which usually works :/ R
  results <- tryCatch({
    suppressWarnings(twitteR::searchTwitter(paste0("#", team_name), n = 2890, since = as.character(date - 1), 
                                             until = as.character(date + 1), retryOnRateLimit = 1e3, lang = "en"))
  },
  error = function(cond) {
    message(cond)
    
  },
  warning = function(cond) {
    message(cond)
  }, finally = {
    twitteR::searchTwitter(paste0("#", team_name), n = 4900, since = as.character(date - 1), 
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


##############################################
###Start of First Plot (Twitter and Sports)###
##############################################\

TweetScorePlot <- function(name, week) {
  
  id <- GetGameID(name, week)
  print(id)
  Sys.sleep(3) #Have to do this due to restrictions on API key
  
  score_df <- GetBoxScore(id)
  preload <- tryCatch({
    preload <- GetPreload(score_df$home_name[1], score_df$away_name[1], week)
    home_score <- preload %>% filter(label == score_df$home_name[1])
    away_score <- preload %>% filter(label == score_df$away_name[1])
    t_count <- preload %>% filter(label == "TWEETS")
    x_axis <- unique(round((preload$formatted - min(preload$formatted)) / 60))
  }, error = function(cond) {
    print(cond)
    t_count <- GetTweetsAboutGame(name, score_df$scheduled, score_df)
    t_count$formatted <- FormatTime(t_count$interval)
    t_count$label <- "TWEETS"
    
    score_df$formatted <- ymd_hms(score_df$time)
    
    if (anyNA(score_df$formatted)) {
      print("NAs INtroduced")
      hours <- hour(score_df$formatted) + score_df$offset
      hours <- ifelse(hours < 0, 24 + hours, hours)
      score_df$formatted <- paste(paste(year(score_df$formatted),month(score_df$formatted),
                                        day(score_df$formatted), sep = "-"),
                                  paste(hours, minute(score_df$formatted),
                                      second(score_df$formatted), sep = ":"))
      score_df$formatted <- ymd_hms(score_df$formatted)
      score_df$formatted <- FillNAs(score_df$formatted)
    } else {
      print("NO NAs Introduced")
      score_df$formatted <- hms(paste(hour(score_df$formatted), minute(score_df$formatted), 
                                    second(score_df$formatted), sep = ":"))
    }
    
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
    scores$formatted <- as.numeric(scores$formatted)
    write.csv(scores, paste0("./csv_files/", home_score$label[1],"_",away_score$label[1],"_",week,".csv"), row.names = FALSE)
    x_axis <- round(scores$formatted - min(scores$formatted) / 60)
    p <- ggplot() + geom_line(data = away_score, aes(x = as.numeric(formatted), y = score, group = 1, color = label)) +
             geom_line(data = home_score, aes(x = as.numeric(formatted), y = score, group = 1, color = label)) + 
             geom_line(data = t_count, aes(x = as.numeric(formatted), y = num_tweets, group = 1, color = label)) + 
             scale_y_continuous(sec.axis = sec_axis(~.*1, name = "Tweets")) + 
             scale_x_discrete(labels = x_axis) + theme(axis.text.x=element_text(colour="blue",size=10)) +
             labs(title = "Scores vs Tweets", x = "Elapsed Time (minutes)", y = "Score")
  return(p)
  })
    
  ggplot() + geom_line(data = away_score, aes(x = as.numeric(formatted), y = score, group = 1, color = label)) +
    geom_line(data = home_score, aes(x = as.numeric(formatted), y = score, group = 1, color = label)) + 
    geom_line(data = t_count, aes(x = as.numeric(formatted), y = num_tweets, group = 1, color = label)) + 
    scale_y_continuous(sec.axis = sec_axis(~.*1, name = "Tweets")) + 
    scale_x_discrete(labels = x_axis) + theme(axis.text.x=element_text(colour="blue",size=10)) +
    labs(title = "Scores vs Tweets", x = "Elapsed Time (minutes)", y = "Score")
  
}

##Fill NA values in hms format
FillNAs <- function(q) {
  count <- 1
  r <- c()
  for (i in q) {
    if(is.na(i)) {
      r <- c(r, count)
    }
    count <- count + 1
  }
  
  u <- paste(floor((hour(q[r + 1]) + hour(q[r - 1])) / 2), 
             floor((60 - minute(q[r + 1]) + minute(q[r - 1])) /2), 
             floor((60 - second(q[r + 1]) + second(q[r - 1]))/2), sep = ":")
  q <- suppressWarnings(hms(paste(hour(q), minute(q), second(q), sep = ":")))
  q[r] <- hms(u)
  return(q)
  
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

#Retrieve a preloaded csv for analysis 
GetPreload <- function(h_name, a_name, week) {
  preload <- read.csv(paste0("./csv_files/", h_name,"_", a_name, "_", week, ".csv"), stringsAsFactors = FALSE)
}


################################################
######This is the start of the second plot######
################################################

#Does not use twitter api, only sportTrader thank god

PlotPlayerStats <- function(team, player) {
  name_id <- read.csv("./csv_files/teamnames-ids.csv", stringsAsFactors = FALSE)
  id <- name_id %>% filter(str_detect(name, paste0("(?i)",team)))
  team_roster_url <- paste0("https://api.sportradar.us/nfl/official/trial/v5/en/teams/", id$id,
  "/full_roster.JSON?api_key=",nfl_key)
  response <- GET(team_roster_url)
  body <- httr::content(response, "text")
  results <- fromJSON(body)
  player_info <- results$players %>% select(id, name)
  p_id <- player_info %>% filter(tolower(name) == tolower(player))
  
  Sys.sleep(1.5)
  
  player_stats_url <- paste0("https://api.sportradar.us/nfl/official/trial/v5/en/players/", 
                             p_id$id, "/profile.JSON?api_key=", nfl_key)
  response <- GET(player_stats_url)
  body <- httr::content(response, "text")
  player_results <- fromJSON(body)
  temp <- player_results$seasons$teams
  start_year <- player_results$rookie_year
  seasons <- player_results$seasons %>% select(year)
  stats <- data.frame(matrix(ncol = 2, nrow = 0))
  if ("passing" %in% colnames(temp[[1]]$statistics) | "rushing" %in% colnames(temp[[1]]$statistics)) {
    names <- c("i", "touchdowns")
    colnames(stats) <- names
    
    for (i in 1:length(temp)) {
      if (!is.null(temp[[i]]$statistics$passing)) {
        print(!is.null(temp[[i]]$statistics$passing))
        s <- temp[[i]]$statistics$passing %>% select(touchdowns)
      }
      if (!is.null(temp[[i]]$statistics$rushing)) {
        s <- s + temp[[i]]$statistics$rushing %>% select(touchdowns)
      }
      interm <- data.frame(i, s)
      stats <- rbind(stats, interm)
    }
    p_data <- data.table(stats, seasons) %>% group_by(year)  %>% summarize(Touchdowns = sum(touchdowns))
    x_axis <- seq(start_year, start_year + nrow(p_data) - 1, by = 1)
    ggplot(data = p_data, aes(year, Touchdowns, fill = Touchdowns)) + geom_bar(stat = "identity") + labs(title = "Touchdowns per Year", x = "Year") + 
      geom_text(color = "black", label = p_data$Touchdowns, nudge_y = 2)
  } else {
    names <- c("i", "tackles")
    colnames(stats) <- names
    
    for (i in 1:length(temp)) {
      if (is.na(temp[[i]]$statistics$defense)) {
        interm <- data.frame(i, temp[[i]]$statistics$defense %>% select(tackles))
      }
      stats <- rbind(stats, interm)
    }
    p_data <- data.table(stats, seasons) %>% group_by(year)  %>% summarize(Tackles = sum(tackles))
    x_axis <- seq(start_year, start_year + nrow(p_data) - 1, by = 1)
    ggplot(data = p_data, aes(year, Tackles, fill = Tackles)) + geom_bar(stat = "identity") + labs(title = "Tackles per Year", x = "Year") +
      geom_text(color = "black", label = p_data$Tackles, nudge_y = 2)
  }

}










