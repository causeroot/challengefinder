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
./generateWordList modelName/classPlusDescriptiveWords
./generateFeatures modelName class1PlusDescriptiveWords.siteWords class2PlusDescriptiveWords.siteWords
createFeatureSets
./trainSVM


trainSvm

siteClassify

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
