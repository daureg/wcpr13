#! /usr/bin/python2
# vim: set fileencoding=utf-8
"""read input (essay.csv) and extract only the text part"""
import sys

text = []
f = open(sys.argv[1])
w = open('texts.txt', 'w')
for line in f:
    w.write(line[line.find(',')+2:-22].strip()+'\n')

f.close()
w.close()
