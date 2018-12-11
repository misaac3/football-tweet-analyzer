import tweepy
import csv
consumer_key = "FFuenK6DaXIw4OiKFYagTDy6J"
consumer_secret = "4wWFRXWAdLXNfgmvo5eYiuCspl2ugyVqXBdJZPR4LcOBqiNb8e"

access_token = "1072216336259002368-pW3IGbVm38hGG5gFTyw3W7uEh6irIg"
access_token_secret = "IocFyre5MmvQWS8cYGIvUOQvDlVZE0Zi1EP2LLz2qQAPJ"
# auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
# auth.set_access_token(access_token, access_token_secret)
#
# api = tweepy.API(auth)
#
#
# # override tweepy.StreamListener to add logic to on_status
# class MyStreamListener(tweepy.StreamListener):
#
#     def on_status(self, status):
#         with open("premIDs.txt", "a", encoding="utf-8") as f:
#             f.write(status.text)
#
#
#
# myStreamListener = MyStreamListener()
# myStream = tweepy.Stream(auth = api.auth, listener=myStreamListener)
# myStream.filter(track=['soccer'])

def get_all_tweets(screen_name):
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
    # keep grabbing tweets until there are no tweets left to grab
    while len(new_tweets) > 0 and c < 5:
        c += 1
        print("getting tweets before %s" % (oldest))

        # all subsiquent requests use the max_id param to prevent duplicates
        new_tweets = api.user_timeline(screen_name=screen_name, count=200, max_id=oldest)

        # save most recent tweets
        alltweets.extend(new_tweets)

        # update the id of the oldest tweet less one
        oldest = alltweets[-1].id - 1

        print("...%s tweets downloaded so far" % (len(alltweets)))

        # transform the tweepy tweets into a 2D array that will populate the csv
        outtweets = [[tweet.id_str, tweet.created_at, tweet.text] for tweet in alltweets]

        for line in outtweets:
            text = line[2]

            text = text.split('\n')


            line[2] = " ".join(text)
            line[2].replace('&amp', 'and')

            print(line)

            # write the csv
        with open('EPL_tweets.csv', 'a', encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["id","created_at","text"])
            writer.writerows(outtweets)

        pass


if __name__ == '__main__':
    # pass in the username of the account you want to download
    get_all_tweets("OptaJoe")
