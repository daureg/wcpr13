#! /usr/bin/python2
# vim: set fileencoding=utf-8
from nltk.tag import pos_tag
from nltk.tokenize import word_tokenize, sent_tokenize
from nltk.stem import WordNetLemmatizer
from collections import defaultdict
with open('small.corpus') as f:
    first = f.readlines()[0].strip()

pos = []
posd = defaultdict(int)
wnl = WordNetLemmatizer()

print(len(first))
for s in sent_tokenize(first):
    print(len(s))
    wk = word_tokenize(s)
    pos += pos_tag(wk)
    for w in wk:
        print(wnl.lemmatize(w))

for p in pos:
    posd[p[1]] += 1

print(posd)
