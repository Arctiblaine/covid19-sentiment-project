### Archie Rincon
### ISTA 498 Capstones - Twitter Sentinment Analysis
### graphing.R - takes my file and makes graphs with it.
###   Currently playing around with graphs.

## lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C")
## Sys.setlocale("LC_TIME", lct)

# load libraries first
library(dplyr)
library(ggplot2)
library(tidyr)
library(Kendall)

# load file
twitter <- read.csv("C:/Users/snowy/Downloads/2022s/ista498/covid-project/Twitter_Sentiment_Final.csv")
stats <- read.csv("C:/Users/snowy/Downloads/2022s/ista498/covid-project/Twitter_Sentiment_Final_averages.csv", comment.char="#")

# data manipulation right here
twitter$date <- sort(as.Date(twitter$date, format="%m/%d/%Y")) # for sorted dates
stats$date <- sort(as.Date(stats$date, format="%m/%d/%Y")) # for sorted dates

twitter$Compound.Score <- twitter$Compound.Score * 100
twitter$Positive.Score <- twitter$Positive.Score * 100
twitter$Negative.Score <- twitter$Negative.Score * 100

stats$compound.average <- stats$compound.average * 100
stats$positive.average <- stats$positive.average * 100
stats$negative.average <- stats$negative.average * 100

# we don't want to graph the zeroes
# only make it NA when the sentiment not Neutral.

# actually graphing stuff
compound <- ggplot(data=stats, aes(`date`, `compound.average`)) +
  geom_line(color="black") + 
  theme(axis.text.x = element_text(size=10, angle=45)) +
  xlab("Dates") + ylab("Sentiment") + 
  ggtitle("Averages of the Compound Sentiment")

compound <- compound + stat_smooth(method="lm",
                                   formula = y ~ x,
                                   geom = "smooth")
compound

negative <- ggplot(data=stats, aes(`date`, `negative.average`)) +
  geom_line(color="black") + 
  theme(axis.text.x = element_text(size=10, angle=45)) +
  xlab("Dates") + ylab("Sentiment") + 
  ggtitle("Averages of the Negative Sentiment")

negative <- negative + stat_smooth(method="lm",
                                   formula = y ~ x,
                                   geom = "smooth")

negative

positive <- ggplot(data=stats, aes(`date`, `positive.average`)) +
  geom_line(color="black") + 
  theme(axis.text.x = element_text(size=10, angle=45)) + 
  xlab("Dates") + ylab("Sentiment") + 
  ggtitle("Averages of the Positive Sentiment")

positive <- positive + 
  stat_smooth(method="lm",
              formula = y ~ x,
              geom = "smooth")

# get where all tweets are negative, positive, neutral. there will be four dfs.
covid <- subset(twitter, Name == "Covid" | Name == "#Covid")
COVID19 <- subset(twitter, Name == "COVID19" | Name == "#COVID19")
coronavirus <- subset(twitter, Name == "coronavirus" | Name == "#coronavirus")
covid.19 <- subset(twitter, Name == "covid-19" | Name == "#covid_19")

DF <- rbind(data.frame(fill="red", obs=covid$Polarity),
            data.frame(fill="green", obs=COVID19$Polarity),
            data.frame(fill="blue", obs=coronavirus$Polarity),
            data.frame(fill="yellow", obs=covid.19$Polarity))

gg <- ggplot(DF, aes(x=obs, fill=fill)) +
  geom_bar(binwidth=1, color='black') +
  scale_fill_identity()

gg <- gg + ylab("Amount of Tweets") + xlab("") +
  ggtitle("Different Sentiments across Hashtags")

gg
