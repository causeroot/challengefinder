Challenge_Finder
========================================

Challenge Finder's purpose is to machine learning techniques to find
technical challenges based on an example set. For the purposes of this
document the list of known good URLs will be called 'good_urls'.



Lifecycle of a generating a new URL list:
=========================================

HIGH LEVEL COMMAND:
This is the command that you would run to receive a new list of URLs that
you are looking for.  Also, those URLs are assessed for their fitness, and
new search strings are generated.

./fullRun className

# Insert Human here - they put new URLs into either a "good" bucket (ie, meets
# the criteria for the type of URLs you want to find) or the "bad" bucket (not
# the URLs that you're looking for).  These files are
# 'rawSiteData/goodBucket/goodChallengesList.sitewords' and
# 'rawSiteData/badBucket/badChallengesList.sitewords' respectively - relative
# the to "Class Folder" (folder within 'data/').


INDIVIDUAL STEP-BY-STEP:
Here are the individual step walkthrough/breakdown for what happens during a
full cycle of Challenge Finder.

# TODO(luis): Clean-up code & remove commented old code for octave
# TODO(roux): make tab completion work for model names and class files.
# TODO: Write in exception handling if the helper referenced files don't exist

./generateWordList className goodList.url
./generateWordList className badList.url
./generateFeatures className
./generateSVM className
./generateSearchStrings className
./webSearch className
./jsonStrip data/className/urls/newUrlList.res data/className/urls/newUrlList.url
./generateWordList className newlySearchedOutput.url
./generateClassification className
########### Insert Human here!!! ###########


# TODO: Figure exactly how we should be using this script most effectively
./merger data/urls/modelName/good_urls data/searchTerms/new_urls



Structure of Data:
========================================

- All of the "classes" (types of searches) are housed in the 'data/' directory
- All of the functions are housed in the 'src/' directory
#TODO: Elaborate on this section:

#Previous Words:
'data/urls is input for word_features
data/urls contains a folder per model type used by siteClassify
data/urls/modelName contains a file for each class used by the classifier model
and an extra file for unclassified input
data/rawSiteData contains input for generateFeatures in same per-model structure'




Build instructions:
===================

1. To build webSearch go to `backend/src/siteRetrieval/webSearch` and run:
`gcc -g webSearch.c -lssl -lcrypto -o webSearch`

2. To build the octave bindings for svm start octave in `backend/libsvm-3.17/matlab`
then from the octave command line run `make`

3. To create a new class, copy one of the existing "classFolders", rename it, and
modify the contents of 'rawSiteData/goodBucket/goodChallengesList.sitewords' and
'rawSiteData/badBucket/badChallengesList.sitewords' to characterize the type of URLs
that you are interested in finding.

4. Run the command (or command sequence) indicated above

5. Iterate to improve your results!!!
