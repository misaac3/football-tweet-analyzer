import tweepy
import csv
import re

consumer_key = "****"
consumer_secret = "****"

access_token = "****"
access_token_secret = "***"


def get_all_tweets(screen_name, label):
    # Twitter only allows access to a users most recent 3240 tweets with this method

    # authorize twitter, initialize tweepy
    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    api = tweepy.API(auth)

    # initialize a list to hold all the tweepy Tweets
    alltweets = []

    # make initial request for most recent tweets (200 is the maximum allowed count)
    new_tweets = api.user_timeline(screen_name=screen_name, count=200)

    # save most recent tweets
    alltweets.extend(new_tweets)

    # save the id of the oldest tweet less one
    oldest = alltweets[-1].id - 1
    c = 0

    # ---------------------------------------------------------------
    for status in tweepy.Cursor(api.user_timeline, screen_name=screen_name, count=200, max_id=oldest, tweet_mode="extended").items():
        # process status here
        text = status.full_text

        text = text.split('\n')
        text = " ".join(text)

        # replace &amp with and
        text.replace('&amp;', 'and')
        text = re.sub(r'http\S+', '', text)

        # write the csv
        with open('tweets.csv', 'a', encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow([text, label])
        pass
        print(text)

    return


    # ---------------------------------------------------------------
    # keep grabbing tweets until there are no tweets left to grab
    # while len(new_tweets) > 0 and c < 1:
    #     c += 1
    #     print("getting tweets before %s" % (oldest))
    #
    #     # all subsiquent requests use the max_id param to prevent duplicates
    #     new_tweets = api.user_timeline(screen_name=screen_name, count=200, max_id=oldest, tweet_mode="extended")
    #
    #     # save most recent tweets
    #     alltweets.extend(new_tweets)
    #
    #     # update the id of the oldest tweet less one
    #     oldest = alltweets[-1].id - 1
    #
    #     print("...%s tweets downloaded so far" % (len(alltweets)))
    #
    #     # transform the tweepy tweets into a 2D array that will populate the csv
    #     outtweets = [[tweet.full_text] for tweet in alltweets if hasattr(tweet, "full_text")]
    #
    #     for line in outtweets:
    #         # remove \n
    #         text = line[0]
    #         text = text.split('\n')
    #         line[0] = " ".join(text)
    #         line[0] = line[0].strip("…")
    #
    #         # replace &amp with and
    #         line[0].replace('&amp;', 'and')
    #         line[0] = re.sub(r'http\S+', '', line[0])
    #
    #         # write the csv
    #     with open('tweets.csv', 'a', encoding="utf-8") as f:
    #         writer = csv.writer(f)
    #         writer.writerow(["text", "label"])
    #         for line in outtweets:
    #             writer.writerow([line[0], label])
    #     pass


if __name__ == '__main__':
    # pass in the username of the account you want to download
    with open('tweets.csv', 'a', encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["text", "label"])
    pass
    get_all_tweets("NFLResearch", "0")
    get_all_tweets("OptaJoe", "1")
    print("Done!")
