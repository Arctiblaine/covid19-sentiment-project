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

timeline <- c(as.Date("2020-03-14",  format="%Y-%m-%d"), as.Date("2020-03-19",  format="%Y-%m-%d"), as.Date("2020-03-25",  format="%Y-%m-%d"),
              as.Date("2020-04-03",  format="%Y-%m-%d"), as.Date("2020-04-08",  format="%Y-%m-%d"), as.Date("2020-04-15",  format="%Y-%m-%d"),
              as.Date("2020-05-11",  format="%Y-%m-%d"), as.Date("2020-08-27",  format="%Y-%m-%d"), as.Date("2020-12-10",  format="%Y-%m-%d"),
              as.Date("2020-12-18",  format="%Y-%m-%d"), as.Date("2021-02-27",  format="%Y-%m-%d"), as.Date("2021-08-23",  format="%Y-%m-%d"),
              as.Date("2021-11-02",  format="%Y-%m-%d"))

timeline.colors <- c("#FFFDEA", "black", "#A261CF", "#75A8FF", "#00B4D6",
                     "#B2E2BD", "#236925", "#99FF9C", "#B4CD3C", "#F9E255",
                     "#FF7360", "#5A4534", "#C1272D")

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
  theme(axis.text.x = element_text(size=10, angle=0),
          panel.background = element_rect(fill='transparent'),
          plot.background = element_rect(fill='transparent', color=NA),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.background = element_rect(fill='transparent'),
          legend.box.background = element_rect(fill='transparent')
        ) +
  xlab("Dates") + ylab("Sentiment") + 
  ggtitle("Averages of the Compound Sentiment")

compound <- compound + stat_smooth(method="lm",
                                   formula = y ~ x,
                                   geom = "smooth")

compound <- compound + xlim(c(as.Date("2020-03-14",  format="%Y-%m-%d"),
                            as.Date("2022-02-22",  format="%Y-%m-%d")))

compound <- compound + geom_vline(xintercept=timeline,
                                   color=timeline.colors, 10)

compound

negative <- ggplot(data=stats, aes(`date`, `negative.average`)) +
  geom_line(color="black") + 
  theme(axis.text.x = element_text(size=10, angle=0), 
        panel.background = element_rect(fill='transparent'),
        plot.background = element_rect(fill='transparent', color=NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.background = element_rect(fill='transparent'),
        legend.box.background = element_rect(fill='transparent')) +
  xlab("Dates") + ylab("Sentiment") + 
  ggtitle("Averages of the Negative Sentiment")

negative <- negative + stat_smooth(method="lm",
                        formula = y ~ x,
                        geom = "smooth")

negative <- negative + xlim(c(as.Date("2020-03-14",  format="%Y-%m-%d"),
                              as.Date("2022-02-22",  format="%Y-%m-%d")))

negative <- negative + geom_vline(xintercept=timeline,
                                  color=timeline.colors, 10)

negative

positive <- ggplot(data=stats, aes(`date`, `positive.average`)) +
  geom_line(color="black") + 
  theme(axis.text.x = element_text(size=10, angle=0),
        panel.background = element_rect(fill='transparent'),
        plot.background = element_rect(fill='transparent', color=NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.background = element_rect(fill='transparent'),
        legend.box.background = element_rect(fill='transparent')) + 
  xlab("Dates") + ylab("Sentiment") + 
  ggtitle("Averages of the Positive Sentiment")

positive <- positive + stat_smooth(method="lm",
              formula = y ~ x,
              geom = "smooth")

positive <- positive + xlim(c(as.Date("2020-03-14",  format="%Y-%m-%d"),
                  as.Date("2022-02-22",  format="%Y-%m-%d")))

positive <- positive + geom_vline(xintercept=timeline,
                                  color=timeline.colors, 10)

positive

# get where all tweets are negative, positive, neutral. there will be four dfs.
covid <- subset(twitter, Name == "Covid" | Name == "#Covid")
COVID19 <- subset(twitter, Name == "COVID19" | Name == "#COVID19")
coronavirus <- subset(twitter, Name == "coronavirus" | Name == "#coronavirus")
covid.19 <- subset(twitter, Name == "covid-19" | Name == "#covid_19")


# red: covid+#covid polarities
# green: covid19+#covid19 polarities
# blue: coronavirus+#coronavirus polarities
# yellow: covid-19+#covid_19 polarities
DF <- rbind(data.frame(fill="red", obs=covid$Polarity),
            data.frame(fill="green", obs=COVID19$Polarity),
            data.frame(fill="blue", obs=coronavirus$Polarity),
            data.frame(fill="yellow", obs=covid.19$Polarity))

gg <- ggplot(DF, aes(x=obs, fill=fill)) +
  geom_bar(color='black') +
  scale_fill_identity()

gg <- gg + ylab("Amount of Tweets") + xlab("") +
  ggtitle("Amount of Sentiments across Hashtags")

gg


# header for website
header <- ggplot(data=stats, aes(`date`, `compound.average`)) +
  geom_line(color="#F5F8FA") + 
  theme(axis.text.x = element_text(size=10, angle=0),
        panel.background = element_rect(fill='transparent'),
        plot.background = element_rect(fill='#14171A', color=NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.background = element_rect(fill='transparent'),
        legend.box.background = element_rect(fill='transparent'))

header <- header + stat_smooth(method="lm",
                                   formula = y ~ x,
                                   geom = "smooth")

header <- header + xlim(c(as.Date("2020-03-14",  format="%Y-%m-%d"),
                              as.Date("2022-02-22",  format="%Y-%m-%d")))

header <- header + geom_vline(xintercept=timeline,
                                  color=timeline.colors, 10)

header
