### Archie Rincon
### ISTA 498 Capstones - Twitter Sentiment Analysis - Word Cloud
### graphing.R - takes my file and makes word clouds with it.

library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(tm)

twitter <- read.csv("C:/Users/snowy/Downloads/2022s/ista498/covid-project/Twitter_Sentiment_Final.csv")

twitter.says <- read.csv("C:/Users/snowy/Downloads/2022s/ista498/covid-project/twitter-says.csv")


text.2 <- sample(twitter.says$words, 5000, replace=TRUE)
text <- sample(twitter$tweet, 5000, replace=TRUE)

gsub("https\\S*", "", text) 
gsub("@\\S*", "", text) 
gsub("amp", "", text) 
gsub("[\r\n]", "", text)
gsub("[[:punct:]]", "", text)
gsub("\"", "", text)
gsub('"', "", text)

gsub("https\\S*", "", text.2) 
gsub("@\\S*", "", text.2) 
gsub("amp", "", text.2)
gsub("[\r\n]", "", text.2)
gsub("[[:punct:]]", "", text.2)
gsub("\"", "", text.2)
gsub('"', "", text.2)

docs.2 <- iconv(text, to = "UTF-8")
docs.2 <- Corpus(VectorSource(text))

docs <- iconv(text, to = "UTF-8")
docs <- Corpus(VectorSource(text))

docs.2 <- docs.2
docs.2 <-tm_map(removeNumbers)
docs.2 <-tm_map(removePunctuation)
docs.2 <-tm_map(stripWhitespace)
docs.2 <- tm_map(docs.2, content_transformer(tolower))
docs.2 <- tm_map(docs.2, removeWords, stopwords("english"))

docs <- tm_map(removeNumbers)
docs <- tm_map(removePunctuation)
docs <- tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))

dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)

dtm.2 <- TermDocumentMatrix(docs.2) 
matrix.2 <- as.matrix(dtm.2) 
words.2 <- sort(rowSums(matrix.2),decreasing=TRUE) 
df.2 <- data.frame(word = names(words),freq=words)


wordcloud(words = df$word, freq = df$freq, min.freq = 1,           
          max.words=300, random.order=FALSE, rot.per=0.45,            
          colors=brewer.pal(8, "Dark2"))

wordcloud(words = df.2$word, freq = df.2$freq, min.freq = 1,           
          max.words=300, random.order=FALSE, rot.per=0.45,            
          colors=brewer.pal(8, "Dark2"))
