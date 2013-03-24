#!/usr/bin/python
#
# This program scrapes all the text from a text file, assuming that the html tags have already
# been removed. The output consists of: 
# - An alphabetized list of the words in the file
# - The frequency that those words are used
# - An alphabetized list of the word pairs in the file
# - The frequency that those word pairs are used

import commands
from itertools import izip, tee
import sys, os

def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = tee(iterable)
    next(b, None)
    return izip(a, b)

corpus_words = list()
corpus_unique_words = set()
corpus_pairs = list()
corpus_unique_pairs = set()

if len(sys.argv) < 2:
    sys.stderr.write('Usage: %s filename',sys.argv[0] )
    sys.exit(1)

if not os.path.exists(sys.argv[1]):
    sys.stderr.write('ERROR: Database %s was not found!',sys.argv[1])
    sys.exit(1)

urlfile = open(sys.argv[1])
outfile = open(sys.argv[1]+'.out','w')
urldata = {}
svmfile = open('svminputfile.tmp','w')


for url in urlfile:
    words = list()
    url = url.strip()
    print 'url is: ', url
    site_text = commands.getoutput('lynx -dump ' + url)
    # ***** ADD SOME [if this shit fails] CODE IN HERE !!! ********
    
    
    # This strips non-alphabet characters from the file, returns, and URLs
    # as it throws every 'word' and 'word pair' into respective arrays
    for word in site_text.lower().split(' '):
        if word != '':
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
    
    # This determines the frequency of each word
    unique_words = set(words)
    word_frequency = dict([(word, words.count(word)) for word in unique_words])
    
    # This creates the word-pairs list and obtains frequency information
    
    pairs = [pair for pair in pairwise(words)]
    unique_pairs = set(pairs)
    pair_frequency = dict([(pair,pairs.count(pair)) for pair in unique_pairs])
    
    # This adds all of the crunched data for the that particular url
    urldata[url] = {'url':url, 'site_text':site_text, 'word_list':words, 'word_frequency':word_frequency,
        'pair_list':pairs,'pair_frequency':pair_frequency}
    
    #url_data.append([url, word_list, word_frequency, key_mapping_words, pair_list, pair_frequency, key_mapping_pairs])
    
    corpus_words.append(words)
    corpus_unique_words.update(unique_words)
    corpus_pairs.append(pairs)
    corpus_unique_pairs.update(unique_pairs)
    
    outfile.write(url + " ")
    outfile.write(' '.join(urldata[url]['word_list']) + '\n')



corpus_word_frequency = dict([(word, corpus_words.count(word)) for word in corpus_unique_words])
corpus_pair_frequency = dict([(pair, corpus_pairs.count(pair)) for pair in corpus_unique_pairs])

urlfile.close()
outfile.close()

# The End ... ?
