### Archie Rincon
### ISTA 498 - Capstones
### sentiment-testing.py - testing out TextBlob
import pandas as pd
import numpy as np
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

def open_csv(filename):
    df = pd.read_csv(filename)
    return df


def analyze(df):
    sid_obj = SentimentIntensityAnalyzer()
    # only analyze ONE ROW

    for i in range(len(df)):
        overall = ''
        sentence = sentence = df.loc[i].tweet
        sentiment_dict = sid_obj.polarity_scores(sentence)
        neg = sentiment_dict['neg']*100
        neu = sentiment_dict['neu']*100
        pos = sentiment_dict['pos']*100
        # decide sentiment as positive, negative and neutral
        if sentiment_dict['compound'] >= 0.05 :
            overall = "Positive"
        elif sentiment_dict['compound'] <= -0.05 :
            overall = "Negative"
        else:
            overall = "Neutral"

        # set the row values to the now calculated values
        df.loc[i,"neg"] = neg
        df.loc[i,"neu"] = neu
        df.loc[i,"pos"] = pos
        df.loc[i,"compound"] = overall

    return df


def to_csv(df, path):
    df.to_csv(path + ".csv", index=False)
    

def add_rows(df):
    # right now, just make the rows nulls until we get there
    # gotta add it four(?) times
    row = np.full(len(df), np.nan)
    df = df.assign(neg = row)
    df = df.assign(neu = row)
    df = df.assign(pos = row)
    df = df.assign(compound = row)

    return df


def main():
    names = ["#Covid", "#COVID19", "#coronavirus", "#covid_19",
                    "Covid", "COVID19", "coronavirus", "covid-19"]
    path = "C:/Users/snowy/Downloads/2022s/ista498/covid-project/clean_tweets/"
    to_save = "C:/Users/snowy/Downloads/2022s/ista498/covid-project/analyzed_tweets/"
    for name in names:
        filename = path + name + ".csv"
        df = open_csv(filename)
        # make new rows first before appending rows
        # does the group want all of this information or not?
        df = add_rows(df)
        df = analyze(df)
        to_csv(df, to_save + name)

        print("one file has finished")
        
# main
if __name__ == "__main__":
    main()
