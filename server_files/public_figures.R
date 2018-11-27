library(twitteR)
<<<<<<< Updated upstream
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
=======
source(keys.R)
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


tw = twitteR::searchTwitter('#yanny', n = 1000, since = '2000-11-08', retryOnRateLimit = 1e3)
d = twitteR::twListToDF(tw)
print(d$text)  

View(d)


tw = twitteR::getTrends(woeid = 12798949, exclude = NULL)
`twitteR::get

woeid = twitteR::availableTrendLocations[1, "woeid"]
t1 <- getTrends(woeid)

trends <- getTrends(2459115)
head(trends)

trendLocation <- availableTrendLocations()
trendLocation
>>>>>>> Stashed changes
