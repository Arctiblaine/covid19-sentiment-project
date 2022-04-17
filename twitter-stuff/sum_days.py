### Archie Rincon
### ISTA 498  Capstones
### sum_days.py - Getting all hashtags from the hashtag column!

import pandas as pd, numpy as np, matplotlib.pyplot as plt

def data_from_each_day(df):
    # CHANGE OF PLANS
    # take every string from the hashtags column, and make a list of every
    # single character from the column. Repeating is allowed. Do not
    # comb down list.
    words = []
    for hashtag in df.hashtags:
        hashtag = hashtag.strip("'").strip(" ").strip("[").strip("]").strip(" ").strip("/n")
        hashtag = hashtag.replace("'", "")
        hashtag = hashtag.replace(" ", "")
        container = hashtag.split(",")
        for item in container:
            if (item == ""):
                continue
            words.append(item)

    return words

def to_csv(words):
    # make a new dataframe of words.
    df_word = pd.Series(data=words, name="words")
    print(df_word.head())
    df_word.to_csv("C:/Users/snowy/Downloads/2022s/ista498/covid-project/twitter-says.csv")

def main():
    df = pd.read_csv("Twitter_Sentiment_Final.csv")
    # load in CSV
    words = data_from_each_day(df)
    to_csv(sorted(words))

if __name__ == "__main__":
    main()
