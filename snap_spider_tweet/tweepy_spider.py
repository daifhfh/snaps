#!/usr/bin/python

import tweepy
from slistener import SListener
import time, sys

consumer_key = 'XpqRhVgJWYHrKob9xW3dQ6izv'
consumer_secret='zAvumvwmsZQ1Q3znsAdafJMsQaC00sFvudznQJd7NeoS5017nZ'
access_token='1244092386-Rb6Hptp1tiRR1ogH1DyHWvQSTT5yFPXXfUS5OV5'
access_token_secret='OUieynWszJs1qw4ABCcRnjFjeh3R0BbGpF8aaSb0XY28j'

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

#public_tweets = api.home_timeline()
#for tweet in public_tweets:
#    print tweet.text
def main():
    track = ['erlespider']
 
    listen = SListener(api, 'erle')
    stream = tweepy.Stream(auth, listen)

    print "Streaming started..."

    try: 
        stream.filter(track = track)
        #stream.filter()
    except IOError as e:
        print "I/O error({0}): {1}".format(e.errno, e.strerror)
        stream.disconnect()

if __name__ == '__main__':
    main()
    #    public_tweets = api.home_timeline()
    #for tweet in public_tweets:
#    print tweet.text
