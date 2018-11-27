users <- read.delim("./users.csv", stringsAsFactors = FALSE, sep = ";")
media <- read.delim("./media.csv", stringsAsFactors = FALSE, sep =";")
View(users)

library(rtweet)
source("keys.R")
token <- create_token(app ="R Shiny analytics project", consumer_key_val, consumer_secret_val)


tw = twitteR::searchTwitter('#maga', n = 1000, since = '2000-11-08', retryOnRateLimit = 1e3)
d = twitteR::twListToDF(tw)
print(d$text)  
View(d)

result <- twitteR::userTimeline('realDonaldTrump')
result$location
user_search <- twitteR::searchTwitter(result$screenName, n = 25)
user_search
result[1:10]


rt <- twitteR::searchTwitter()
