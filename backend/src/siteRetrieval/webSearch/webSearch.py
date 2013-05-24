# Copyright 2013 CauseRoot

import requests
from sys import exit
from os.path import exists

URL = "https://www.googleapis.com/customsearch/v1"


def readLine(fname):
    with open(fname) as f:
        return f.readline().strip()


def getBasePayload(secret):
    return {
            "key":secret,
            "cx":"003397780648636422832:u25rx3s92ro",
            "fields":"items(link)",
            }


def searchGen(url, secret, terms):
    for i in xrange(10):
        payload = getBasePayload(secret)
        payload.update({
            "start":str((i*10)+1),
            "q":terms,
            })
        yield requests.get(url, params=payload)


def main():
    """Make requests to Google Search API using search API"""
    API_SECRET = readLine("google.apikey")
    try:
        API_SECRET
    except NameError:
        print "You absolutely must have a Google API key in 'google.apikey'"
        exit()
    
    if len(argv) < 2 or not exists(argv[1]):
        print "Please pass in the filename containing the search parameters"
        exit()
    
    terms = readLine(argv[1])
    
    searchGenerator = searchGen(URL, secret, terms)
    print searchGenerator.next().json()


if __name__ == "__main__":
    main()

