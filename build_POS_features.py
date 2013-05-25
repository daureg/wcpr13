#! /usr/bin/python2
# vim: set fileencoding=utf-8
from nltk.tag import pos_tag
from nltk.tokenize import word_tokenize, sent_tokenize
from nltk.tag.simplify import simplify_wsj_tag
from collections import defaultdict
from scipy.io import savemat
import numpy as np
with open('small.corpus') as f:
    essays = f.readlines()[0:2]


def get_pos_dict(text):
    pos = []
    posd = defaultdict(int)
    # seems slower, despite the promising name
    # pos = batch_pos_tag(text)
    # pos = [tag for sent in batch_pos_tag(map(word_tokenize,
    #                                          sent_tokenize(text.strip())))
    #        for tag in sent]
    for s in sent_tokenize(text):
        wk = word_tokenize(s)
        pos += pos_tag(wk)

    for p in pos:
        posd[simplify_wsj_tag(p[1])] += 1
    return posd

if __name__ == '__main__':
    # import timeit
    # nrun = 3
    # t = timeit.Timer('get_pos_dict(essays[0])',
    #                  setup="from __main__ import get_pos_dict, essays")
    # print(t.repeat(number=nrun))
    grammar_tag = set([])
    all_pos_tag = map(get_pos_dict, essays)
    for d in all_pos_tag:
        grammar_tag |= set(d.keys())

    grammar_tag = list(grammar_tag)
    with open('pos_tag_list', 'w') as f:
        f.write('\n'.join(grammar_tag))

    N = len(essays)
    N = 2
    POSmat = np.zeros((N, len(grammar_tag)), np.int16)
    for j, tag in enumerate(grammar_tag):
        for i, d in enumerate(all_pos_tag):
            POSmat[i, j] = d[tag]

    savemat('POS', {'POS': POSmat}, do_compression=True, oned_as='row')
