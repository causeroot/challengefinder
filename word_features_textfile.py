##!/usr/bin/python
#
# This program scrapes all the text from a text file, assuming that the html tags have already
# been removed. The output consists of: 
# - An alphabetized list of the words in the file
# - The frequency that those words are used
# - An alphabetized list of the word pairs in the file
# - The frequency that those word pairs are used

filename = raw_input( "Please input the filename you wish to scrape all the words from:" )

file = open(filename)
words = list()
word_pairs = list()
word_pairs = [['' for pair in range(2)] for notion in range(1)]

# This strips non-alphabet characters from the file, returns, and URLs
# as it throws every 'word' and 'word pair' into respective arrays

for line in file:
    for word in line.lower().split(' '):
    	if word != '':
    		word = word.strip('[]{}()0123456789~:;"?><,!%^&*')
    		word = word.replace('\n','')
    		if word.find('-',1,len(word)-1) == -1:
    			word = word.replace('-','')
    		if word.find('www' or 'http' or '.com') == -1:
    			wrd = word.replace('.','')
    			if wrd.isalpha():
    				words.append(word)
    				if len(words) > 1:
    					word_pairs[int(len(words)-2)][1] = word
    					word_pairs.append([word,''])
    				else:
 						word_pairs[0][0] = word

num_of_words = len(words)
word_list = list()
pair_list = list()
word_frequency = list()
pair_frequency = list()
last_one = ''
sorted_words = list(words)
sorted_pairs = list(word_pairs)
sorted_words.sort()
sorted_pairs.sort()

# This alphabetizes the sorted words list, and determines the frequency of each word

for word in sorted_words:
	if word != last_one:
		word_frequency.append(0)
		word_list.append(word)
	word_frequency[len(word_list)-1] += 1
	last_one = word[:]

# This alphabetizes the sorted pairs list, and determines the frequency of each word pair

for pair in sorted_pairs:
	if pair != last_one:
		pair_frequency.append(0)
		pair_list.append(pair)
	pair_frequency[len(pair_list)-1] += 1
	last_one = pair[:]

# The End ... ?