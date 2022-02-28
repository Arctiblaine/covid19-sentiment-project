### Archie Rincon
### ISTA 498 Capstones - COVID-19 Sentiment Project
### one_csv.py - puts all the csvs into one big csv
import pandas as pd
from os import listdir
from os.path import isfile, join
import os
# what i want is to place this file into a folder, and it takes every single csv in there and condenses it into one big csv file.

# get all the file names in the path
def get_file_names(mypath):
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    return onlyfiles


# open every single file and add it to one pandas dataframe.
def add_to_one_df(path, filenames):
    # use pandas here to combine EVERYTHING into one csv.
    first = pd.read_csv(path + filenames[0])
    filenames.pop(0) # because we've already done this file name
    for name in filenames:
        # open the file
        temp = pd.read_csv(path + name)
        # add it to the current/first dataframe
        first = first.append(temp)
    
    return first


# drop rows here
def format_data(df):
    # what rows don't we need?
    to_drop =   ['id', 'conversation_id', 'created_at', 'time', 'timezone', 'user_id', 'username', 'name',
                 'urls', 'photos', 'replies_count', 'retweets_count', 'likes_count', 'cashtags', 'place', 'mentions',
                 'link', 'retweet', 'quote_url', 'video', 'thumbnail', 'near', 'geo', 'source', 'user_rt_id',
                 'user_rt', 'retweet_id', 'reply_to', 'retweet_date', 'translate', 'trans_src', 'trans_dest']

    for item in to_drop:
        df = df.drop(columns=item)
    # drop all unnecessary rows
    return df

def saving_to_csv(df, path):
    df.to_csv(path + ".csv", index=False)    

    
# main
def main():
    names = ["#Covid", "#COVID19", "#coronavirus", "#covid_19",
                    "Covid", "COVID19", "coronavirus", "covid-19"]
    for name in names:
        path = "C:/Users/snowy/Downloads/2022s/ista498/covid-project"
        filenames = get_file_names(path + "/" + name + "/")
        df = add_to_one_df(path  + "/" + name + "/", filenames)
        df = format_data(df)
        saving_to_csv(df, path + "/" + name)
    
# main
if __name__ == "__main__":
    main()
