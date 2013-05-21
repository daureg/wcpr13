tr 'A-Z' 'a-z' < $1 | tr -sc 'a-z1é' '\012' | sed -e 's/1/xnumx/g'| sort | uniq -c | sort -rn > dict
sed -i 's/xnumx/1/g' dict
