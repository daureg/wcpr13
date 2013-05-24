#! /usr/bin/python2
# vim: set fileencoding=utf-8
with open('hun') as f:
    morphs = [l.strip() for l in f.readlines()]


def morph_split(line):
    word, stem = line.split('st:')[:2]
    word = word.split()[0].strip()
    stem = stem.split()[0].strip()
    info = None
    if 'fl:' in line:
        info = line.split('fl:')[1].strip()
    return word, stem, info


def choose_stem(stems, infos):
    if len(stems) == 1:
        return stems[0]
    if 'D' in infos:
        return stems[infos.index('D')]
    if 'G' in infos:
        potential = stems[infos.index('G')]
        if potential != 'the':
            return potential
    return stems[0]

morph_index = 0
while morph_index < len(morphs):
    first_word, first_stem, info = morph_split(morphs[morph_index])
    possible_stem = [first_stem]
    infos = [info]
    may_be_other_stem = True
    while may_be_other_stem and morph_index < len(morphs)-1:
        next_word, next_stem, info = morph_split(morphs[morph_index+1])
        if next_word == first_word and next_stem != first_stem:
            possible_stem.append(next_stem)
            infos.append(info)
            morph_index += 1
        else:
            may_be_other_stem = False
    print(choose_stem(possible_stem, infos).lower())
    morph_index += 1
