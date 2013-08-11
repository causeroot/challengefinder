
CHALLENGEFINDER
========================================

The ChallengeFinder backend's purpose is to use Machine Learning techniques to find
certain types of URLs based on an example set of "good" URLs (the types
of sites that you are looking for) and a set of "bad" URLs (the types of
URLs that you are not what you are looking for.


Lifecycle of a Generating a New URL List:
=========================================

HIGH LEVEL COMMAND:
This is the command that you would run to receive a new list of URLs that
you are looking for.  Also, those URLs are assessed for their fitness, and
new search strings are generated.

`./fullRun className`

* Insert Human here - the User puts new URLs into either a "good" bucket (ie,
meets the criteria for the type of URLs you want to find) or the "bad" bucket
(not the URLs that you're looking for). See "Structure of Data" for more
details on the specific filenames that you will be interacting with.


INDIVIDUAL STEP-BY-STEP:
Here are the individual step walk-through/breakdown for what happens during a
full cycle of Challenge Finder.

TODO(luis): Clean-up code & remove commented old code for octave
TODO(roux): make tab completion work for model names and class files.
TODO: Write in exception handling if the helper referenced files don't exist

    ./generateWordList className goodList.url
    ./generateWordList className badList.url
    ./generateFeatures className
    ./generateSVM className
    ./generateSearchStrings className
    ./webSearch className
    ./generateWordList className newUrlList.url
    ./generateClassification className
* Insert Human here!!! (see the note in "High Level Command")

TODO: Figure exactly how we should be using the following script most effectively
`./merger data/urls/modelName/good_urls data/searchTerms/new_urls`


Structure of Data:
========================================

- All of the "classes" (types of searches) are housed in the 'data/' directory
- All of the functions are housed in the 'src/' directory

- The following filenames and locations are specific to each Class:
    - `../urls/goodList.url` : This file is a list of all the URLs that are Positive representations of
      classification that is being implemented. This is the input to the python word list scripts, and
      its contents are maintained by the user, and is human read-able text file.
    - `../urls/badList.url` : This file is a list of all the URLs that are Negative representations of
      classification that is being implemented. This is the input to the python word list scripts, and
      its contents are maintained by the user, and is human read-able text file.                                             -
    - `../urls/excludedUrlList.url` : This file lists all the URLs which should be removed from the results
      of our custum search engine. URLs may be on the exclusion list for low quality, known good challenges
      that are past their end date, or simply sites that have been seen before. This file is periodically
      used to refresh Google's annotations list for the Custom Search Engine.
    - `../rawSiteData/goodList.sitewords` : This file is a list of all the Positive URLs, including all
      of the text based words (in order) on that site.  This is the output from the python word list
      scripts, and is human read-able text file.
    - `../rawSiteData/badList.sitewords` : This file is a list of all the Negative URLs, including all
      of the text based words (in order) on that site.  This is the output from the python word list
      scripts, and is human read-able text file.
    - `../features/dictionary_class_file.binsev` : This file is contains all of the "class" information
      for all of the feature sets.  It is a binary file generated from the "extraction" script and
      must be opened in Octave to view/use.
    - `../features/dictionary_class_file.binsev` : This file is contains all of the "features" information
      for all the URLs.  This includes all words, word pairs, word frequency, and word pair frequency.
      It is a binary file generated from the "extraction" script and must be opened in Octave to view/use.
    - `../urlTerms/dictionary_words_file.binsev` : This file is the dictionary for all the words listed in
      all the good and bad URLs. It is a binary file generated from the "extraction" script and must be
      opened in Octave to view/use.
    - `../urlTerms/dictionary_pairs_file.binsev` : This file is the dictionary for all the word pairs
      listed in all the good and bad URLs. It is a binary file generated from the "extraction" script
      and must be opened in Octave to view/use.
    - `../urlTerms/urls_file.binsev` : This file is just a list of all the good and bad urls, that is
      generated from the extraction script. It is a binary file generated from the "extraction" script
      and must be opened in Octave to view/use.
    - `../svmModel/model.binsev` : This file contains the functional SVM model that can be used for future
      prediction, as generated by TrainSVM.  It is a binary file and must be opened in Octave to view/use.
    - `../svmModel/accuracy.binsev` : This file contains the accuracy of the SVM prediction model when run
      against its own training set. It is a binary file and must be opened in Octave to view/use.
    - `../svmModel/p.binsev` : This file contains the binary prediction of whether the URLs in the good and
      bad bucket lists are predicted as being in the good or the bad bucket.  This is a binary file
      produced by trainSVM, and must be open in Octave to view/use.
    - `../svmModel/pred.binsev` : This file contains a numerical/analog fitness value that indicates
      of how well the good and bad URLs in the training buckets fit the SVM model criteria.  This is a
      binary file produced by trainSVM, and must be open in Octave to view/use.
    - `../searchTerms/newSearchStrings.txt` : This file contains the words and word pairs that should be
      submitted into the Google API, which should be the best indicators for predicting a good URL.
TODO: <Roux> Write a short blurb about the location & function of the passcode file
    - `../urls/newUrlList.url` : This file is the direct output of webSearch.  It is a list of urls, in
      json format, that have been found using the new search strings in new_sstrings.txt
    - `../svmModel/pNew.binsev` : This file contains the binary prediction of whether the newly searched
      URLs output from webSearch meet the criteria to be "good URL".  This is a binary file produced by
      trainSVM, and must be opened in Octave to view/use.
    - `../svmModel/predNew.binsev` : This file contains a numerical/analog fitness value that indicates
      of how well the good and bad URLs in the training buckets fit the SVM model criteria.  This is a
      binary file produced by trainSVM, and must be open in Octave to view/use.
    - `../fitness/evalout.txt` : This file list all of the newly discovered URLs, and contains both the
      pNew and predNew values in the same row as the corresponding URL. It is a text file that is
      produced by the classification script. User can read this file, to look at the URLs that have
      a high likelihood of being a "good" or a "bad" type URL. Once determined by the user, they can
      paste those URLs in the good & bad *.sitewords files mentioned earlier.


Build instructions:
===================

1. To build webSearch go to `backend/src/siteRetrieval/webSearch` and run:
`gcc -g webSearch.c -lssl -lcrypto -o webSearch`

2. To build the octave bindings for svm start octave in `backend/libsvm-3.17/matlab`
then from the octave command line run `make`

TODO: <Luis> Fix step #3 ...

TODO: <ROUX> write in steps to install pip threadinstall
*****
easy_install pip
pip install threadpool
pip install requests
*****

3. To create a new class, copy one of the existing "classFolders", rename it, and
modify the contents of 'rawSiteData/goodList.sitewords' & 'rawSiteData/badList.sitewords'
to characterize the type of URLs that you are interested in finding.

TODO: <Roux> Add the passcode whatnots to the build instructions

4. Run the command (or command sequence) indicated above

5. Iterate to improve your results!!!
