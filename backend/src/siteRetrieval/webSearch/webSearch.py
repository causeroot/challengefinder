# Copyright 2013 CauseRoot

import json
import requests
from sys import argv, exit
from os.path import exists

URL = "https://www.googleapis.com/customsearch/v1"
BASE_PATH = "data"
INPUT_FN = "searchTerms/newSearchStrings.txt"
OUTPUT_FN = "urls/newUrlList.url"
EXCLUSION_FN = "urls/excludedUrlList.url"


def readLine(fname):
    with open(fname) as f:
        return f.readline().strip()


def readLines(fname):
    with open(fname) as f:
        return f.read().split("\n")


def getBasePayload(secret):
    return {
            "key":secret,
            "cx":"003397780648636422832:u25rx3s92ro",
            "fields":"items(link)",
            }


def searchGen(url, secret, terms):
    """
    Generate multiple objects each representing a Google search page. API v1
    """
    for i in xrange(10):
        payload = getBasePayload(secret)
        payload.update({
            "start":str((i*10)+1),
            "q":terms,
            })
        yield requests.get(url, params=payload)

def excludeUrls(urls, exlusionSet):
    return [url for url in urls if url not in exlusionSet]


def main():
    """Make requests to Google Search API using search API"""
    API_SECRET = readLine("src/siteRetrieval/webSearch/google.apikey")
    try:
        API_SECRET
    except NameError:
        print "You absolutely must have a Google API key in 'src/siteRetrieval/webSearch/google.apikey'"
        exit()
    
    if len(argv) < 2:
        print "Please pass in the class Name"
        exit()
    
    inFile = '/'.join([BASE_PATH, argv[1], INPUT_FN])
    outFile = '/'.join([BASE_PATH, argv[1], OUTPUT_FN])
    exclusionFile = '/'.join([BASE_PATH, argv[1], EXCLUSION_FN])

    excludedUrls = readLines(exclusionFile)
    
    if not exists(inFile):
        print "Class does not exist, try again"
        exit()
    
    terms = readLine(inFile)
    
    searchGenerator = searchGen(URL, API_SECRET, terms)

    results = searchGenerator.next().json()
    for result in searchGenerator:
        results[u'items'].extend(result.json()[u'items'])

    cleanResults = [item[u'link'] for item in results[u'items']]
    dedupedResults = excludeUrls(cleanResults, excludedUrls)
    with open(outFile, 'w') as f:
        for item in dedupedResults:
            f.write(item + '\n')

if __name__ == "__main__":
    main()

