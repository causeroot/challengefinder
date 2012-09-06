Challenge_Finder
================

Challenge Finder's purpose is to machine learning techniques to find
technical challenges based on an example set. For the purposes of this
document the list of known good URLs will be called 'good_urls'.

Lifecycle of a URL list:
========================

Taking 'good_urls' as an example, here is what happens during a full cycle
of Challenge Finder.

```bash
python word_features.py good_urls
octave site_classify.m good_urls.out xxx.out searchterms
./websearch searchterms
./json_strip searchterms.txt.res new_urls
./merger good_urls new_urls
```

TODO: modify site_classify to take standard input arguments


