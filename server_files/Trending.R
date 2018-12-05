library(twitteR)
#setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
library(ggplot2)
library(DT)
twitteR::setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# TRENDS BY COUNTRY
australia_trends <- getTrends(23424748)

united_states_trends <- getTrends(23424977)

canada_trends <- getTrends(23424775)

ireland_trends <- getTrends(23424803)

new_zealand_trends <- getTrends(23424916)

philippines_trends <- getTrends(23424934)

united_kingdom_trends <- getTrends(23424975)

# REPLACE ID# WITH NAME OF COUNTRY
australia_trends$woeid[australia_trends$woeid==23424748]  <- "Australia" 

united_states_trends$woeid[united_states_trends$woeid==23424977] <- "United States"

canada_trends$woeid[canada_trends$woeid==23424775] <- "Canada"

ireland_trends$woeid[ireland_trends$woeid==23424803] <- "Ireland"

new_zealand_trends$woeid[new_zealand_trends$woeid==23424916] <- "New Zealand"

philippines_trends$woeid[philippines_trends$woeid==23424934] <- "Philippines"

united_kingdom_trends$woeid[united_kingdom_trends$woeid==23424975] <- "United Kingdom"

# COMBINE SEPERATE COUNTRY DATA IN ONE TABLE
all_country_data <- rbind(united_states_trends, australia_trends, canada_trends, ireland_trends, 
                          new_zealand_trends, philippines_trends, united_kingdom_trends) 
all_country_data$query <- NULL

all_country_data <- setNames(all_country_data, c("trend", "url", "country"))

#write.csv(all_country_data, "trendingdata.csv", row.names = FALSE)

#allcountry_data <- read.csv("trendingdata.csv")
