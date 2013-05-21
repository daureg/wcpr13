labels = textread('selection.txt','%s');
sominputwords = fullmatrix(:,[1,6,15,23,24,26,34,35,43,47,51,57,60,62,66,68,69,73,76,78,89,91,94,96,98,99,100]);
sominputbig5 = big5classifications*0.01;
sominputall = [sominputwords,sominputbig5];
sData = som_data_struct(sominputall, 'comp_names', labels);
sMap = som_make(sData, 'msize', [10 14]);
som_show(sMap, 'comp', 'all', 'footnote', '', 'bar', 'none');
