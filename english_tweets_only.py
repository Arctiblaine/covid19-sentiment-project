### Archie Rincon
### ISTA 498 - Capstones
### english_tweets.py - takes the now cleaned up csvs 
###     and gets rid of all Tweets that are not in English.
# will need a library that can process tweets for us
import re
from langdetect import detect
import pandas as pd

# we need to open the csv first
def open_file(filename):
    df = pd.read_csv(filename)
    return df

# then set up a loop that goes through all tweets.
def filter_tweets(df):
    for i in range(len(df)):
        tweet = remove_all_special_chars(df.loc[i, "tweet"])
        try:
            if (df.loc[i, "language"] != "und"):
                if (detect(tweet) != "en"):
                    df = df.drop(i)
        except:
            # probably not in english.
            df = df.drop(i)

    return df

def to_csv(df, path):
    df.to_csv(path + ".csv", index=False)   

def remove_all_special_chars(text):
    return re.sub(r"\W+|_", " ", text)
    

def main():
    names = ["#Covid", "#COVID19", "#coronavirus", "#covid_19",
                    "Covid", "COVID19", "coronavirus", "covid-19"]
    path = "C:/Users/snowy/Downloads/2022s/ista498/covid-project/formatted_tweets/"
    save_to = "C:/Users/snowy/Downloads/2022s/ista498/covid-project/clean_tweets/"
    for name in names:
        df = open_file(path + name + ".csv")
        df = filter_tweets(df)
        to_csv(df, save_to + name)

if __name__ == "__main__":
    main()
