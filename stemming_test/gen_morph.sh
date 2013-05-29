#! /bin/bash
i=0
while read p; do
  echo $p | hunspell -d en_US -m|grep 'st:' > morph$i;
  i=$(($i + 1))
# done < ../small.corpus
done < ../num_texts.txt
