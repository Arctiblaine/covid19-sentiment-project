### ISTA 498 Capstones Project
### Archie Rincon - 2/15/2022
### get_tweets.py - plays around with getting tweets using Twint.
import twint
import datetime
from datetime import timedelta  
# twitter limits searches up to 7 days.
# we need to chop up searches up until we hit the last date.
# then i need to put the csvs into one big csv
# after that, then we can clean up the data.

def get_tweet(start, end):
    c = twint.Config()
    # we will need a time frame. do i want all tweets? play around with that.
    # what are our search words? search by hashtags and keywords.
    
    # i dont want accounts with the term "covid."
    search_terms = ["#Covid", "#COVID19", "#coronavirus", "#covid_19",
                    "Covid", "COVID19", "coronavirus", "covid-19"]
    # i also want tweets in English.
    # i dont want retweets.
    # i will try this for now, but i will try to use minimum likes.
    # days cannot be the same
    c.Hide_output = True # to keep my damn terminal from being clogged
    c.Since = start
    c.Until = end
    for search in search_terms:
        c.Lang = "en"
        c.Filter_retweets = False
        c.Search = search
        c.Store_csv = True
        c.Output = search + '_' + start + ".csv"
        twint.run.Search(c)
        
    # it is possible to resume scrolling - we just need the filename and scroll ID.

# sometimes twint decides it wants to not work, so we have this.
def get_missed_csv(start, end):
    get_tweet(start, end)


def get_missed_tweets(search_terms, start, end):
    # the shorter version of get_tweets()
    c = twint.Config()
    c.Hide_output = True # to keep my damn terminal from being clogged
    c.Since = start
    c.Until = end
    for search in search_terms:
        c.Lang = "en"
        c.Filter_retweets = False
        c.Search = search
        c.Store_csv = True
        c.Output = search + '_' + start + ".csv"
        twint.run.Search(c)
    

def get_time_frame():
    # start : "2020-3-11"
    # end: "2022-2-22"
    start = datetime.datetime.strptime("2020-03-10", '%Y-%m-%d')
    end = datetime.datetime.strptime("2022-02-22", '%Y-%m-%d')
    for i in range(0, 714, 7):
        end = start + timedelta(days=7)
        # run get_tweets here
        get_tweet(start.strftime("%Y-%m-%d"), end.strftime("%Y-%m-%d"))
        start = start + timedelta(days=7)


def main():
    #get_time_frame()
    #get_missed_csv("2022-02-15", "2022-02-22")
    search_terms = ["Covid", "COVID19", "coronavirus", "covid_19"]
    get_missed_tweets(search_terms, "2022-02-15", "2022-02-22")

if __name__ == "__main__":
    main()
