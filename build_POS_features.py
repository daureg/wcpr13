#! /usr/bin/python2
# vim: set fileencoding=utf-8
from nltk.tag import pos_tag
from nltk.tokenize import word_tokenize, sent_tokenize
from collections import defaultdict
from scipy.io import savemat
import numpy as np
with open('small.corpus') as f:
    essays = f.readlines()[0:2]


def get_pos_dict(text):
    pos = []
    posd = defaultdict(int)
    for s in sent_tokenize(text):
        wk = word_tokenize(s)
        pos += pos_tag(wk)

    for p in pos:
        posd[p[1]] += 1
    return posd

grammar_tag = set([])
all_pos_tag = map(essays, get_pos_dict)
for d in all_pos_tag:
    grammar_tag |= d.keys()

N = len(essays)
POSmat = np.zeros((N, len(grammar_tag)), np.int16)
for j, tag in enumerate(grammar_tag):
    for i, d in enumerate(all_pos_tag):
        POSmat[i, j] = d[tag]

savemat('POS', {'POS': POSmat}, do_compression=True, oned_as='row')
