#!/usr/bin/python
#
# This program scrapes all the text from a text file, assuming that the html tags have already
# been removed. The output consists of: 
# - An alphabetized list of the words in the file
# - The frequency that those words are used
# - An alphabetized list of the word pairs in the file
# - The frequency that those word pairs are used

import commands
import threadpool
from collections import defaultdict
from itertools import izip, tee
import sys, os

def retrieveUrl(url):
    print 'url is: ' + url
    return commands.getoutput('lynx -dump -connect_timeout=60 ' + url)

def parseSiteData(siteText):
    """Return every word in a site's output after cleaning up"""
    # This strips non-alphabet characters from the file, returns, and URLs
    # as it throws every 'word' into an array
    words = []
    for word in siteText.lower().split(' '):
        if word:
            word = word.strip('[]{}()0123456789~:;"?><,!%^&*')
            word = word.replace('\n',' ')
            if word.find('-',1,len(word)-1) == -1:
                word = word.replace('-','')
            if ('www' not in word) and ('http' not in word) and ('.com' not in word):
                word = word.replace('.','')
                if word.isalpha():
                    words.append(word)
            else:
                words.append('httpaddr')
    return words

def siteCb(request, siteText):
    global first
    global OUPUT_PATH
    words = parseSiteData(siteText)
    accessMode = 'a'
    if first:
        accessMode = 'w'
        first = False
    with open(OUPUT_PATH + sys.argv[2][:-4]+'.siteWords', accessMode) as outFile:
        if accessMode == 'a':
            outFile.write('\n')
        outFile.write(url + " " + ' '.join(words))

def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = tee(iterable)
    next(b, None)
    return izip(a, b)

def frequencyCount(items):
    """Create dictionary of counts for an iterable item, optionally take a
    list of unique items to speed up calculation"""
    frequency = defaultdict(lambda: 0)
    for item in items:
        frequency[item] += 1
    return frequency

def processTasks(urlList):
    pool = threadpool.ThreadPool(40)
    
    requests = threadpool.makeRequests(retrieveUrl, urlList, callback=siteCb)
    
    start = True
    for req in requests:
        req.start = start
        pool.putRequest(req)
        if start:
            start = False
    pool.wait()

# TODO: Fix these paths below:
if len(sys.argv) < 2:
  sys.stderr.write('Usage: %s filename filename\n' %sys.argv[0] )
  sys.exit(1)

INPUT_PATH = 'data/' + sys.argv[1] + '/urls/'
OUPUT_PATH = 'data/' + sys.argv[1] + '/rawSiteData/'

if not os.path.exists(INPUT_PATH + sys.argv[2]):
  sys.stderr.write('ERROR: URL list %s was not found!\n' % sys.argv[2])
  sys.exit(1)

first = True

urlList = []
with open(INPUT_PATH + sys.argv[2]) as urlFile:
    urlList = [url.strip() for url in urlFile]

processTasks(urlList)

