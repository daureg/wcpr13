#! /usr/bin/python2
# vim: set fileencoding=utf-8
"""go trough all texts, extract general features and given 'dict' also word
count. save it as wm.mat"""
import sys
from os import getcwd
from os.path import join as path_join
sys.path.insert(0, path_join(getcwd(), 'stemming_test'))
from clean_hunspell import words_to_stems
from nltk.tokenize import word_tokenize, sent_tokenize
from scipy.io import savemat
from string import punctuation, ascii_uppercase
import numpy as np
import sys

voca = {}
with open('dict') as f:
    for i, line in enumerate(f):
        _, word = line.strip().split()
        voca[word] = i+1

with open(sys.argv[1]) as f:
    texts = [i.strip() for i in f.readlines()]

N = len(texts)
V = len(voca)
F = 6
wm = np.zeros((N, F+1+V), np.int16)
for i, t in enumerate(texts):
    num_char = len(t)
    sentences = sent_tokenize(t)
    num_sentences = len(sentences)
    num_words = 0
    num_punct = 0
    num_upper = 0
    for w in words_to_stems(path_join('stemming_test', 'morph'+str(i))):
        if w in voca:
            wm[i, voca[w]+F-1] += 1
    for s in sentences:
        words = word_tokenize(s)
        num_words += len(words)  # including punctuation and OOV
        num_punct = len([w for w in words if w.lower() in punctuation])
        # for w in words:
        #     w = w.lower()
        #     if w in voca:
        #         wm[i, voca[w]+F] += 1
        #     elif w in punctuation:
        #         num_punct += 1
        #     else:  # mostly thing like n't, 's or `` but also jibber-jabber or good~~i
        #         wm[i, F] += 1

        for c in s:
            if c in ascii_uppercase:
                num_upper += 1

    # num_punct /= 1.0*num_char
    # num_upper /= 1.0*num_char
    words_per_sentence = num_words / num_sentences
    wm[i, 0:F] = [num_char, num_words, num_sentences, num_upper, num_punct,
                  words_per_sentence]

savemat('swm', {'wm': wm}, do_compression=True, oned_as='row')
