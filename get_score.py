#! /usr/bin/python2
# vim: set fileencoding=utf-8
"""extract only the score part of the input (essays.csv)"""
import sys

score = []
with open(sys.argv[1]) as f:
    for i, a in enumerate(f):
        score.append(a[-20:].strip())

with open('score.txt', 'w') as f:
    for s in score:
        t = s.replace('"','').replace('n','0').replace('y','1').split(',')
        f.write('\t'.join(t)+'\n')
