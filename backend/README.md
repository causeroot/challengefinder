Challenge_Finder
================

Challenge Finder's purpose is to machine learning techniques to find
technical challenges based on an example set. For the purposes of this
document the list of known good URLs will be called 'good_urls'.

Lifecycle of a URL list:
========================

Taking 'good_urls' as an example, here is what happens during a full cycle
of Challenge Finder.

#TODO(roux): make tab completion work for model names and class files.
./generateWordList className fileName
./generateFeatures className
./generateSVM className
./generateSearchStrings className
#TODO(luis): Clean-up code & remove commented old code
./webSearch className
./jsonStrip data/searchTerms/fileName
# Note fileName is assumed to have .res extension which should NOT be included 
# when calling jsonStrip.
./generateWordList modelName/classPlusDescriptiveWords4
# Insert classification step here
./generateClassification className
# Insert Human here (they look at urls from data/searchTerms/fileName.url)

./merger data/urls/modelName/good_urls data/searchTerms/new_urls




# TODO: Write in exception handling if the helper referenced files don't exist

webSearchFromCurrentModel
# generateSearchString
# webSearch

updateUrls

```bash
python word_features.py good_urls
octave site_classify.m good_urls.out xxx.out searchterms
./webSearch searchterms
./json_strip searchterms.txt.res new_urls
./merger good_urls new_urls
```

TODO: modify site_classify to take standard input arguments


Structure of data (and life in general):
========================================

data/urls is input for word_features
data/urls contains a folder per model type used by siteClassify
data/urls/modelName contains a file for each class used by the classifier model
  and an extra file for unclassified input
  
data/rawSiteData contains input for generateFeatures in same per-model structure

(we're going to move to data containing file structure per model)

Build instructions:
===================

To build webSearch go to `backend/src/siteRetrieval/webSearch` and run:
`gcc -g webSearch.c -lssl -lcrypto -o webSearch`

To build the octave bindings for svm start octave in `backend/libsvm-3.17/matlab`
then from the octave command line run `make`

