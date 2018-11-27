users <- read.delim("./users.csv", stringsAsFactors = FALSE, sep = ";")
media <- read.delim("./media.csv", stringsAsFactors = FALSE, sep =";")
View(users)

library(twitteR)
source("keys.R")
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


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
