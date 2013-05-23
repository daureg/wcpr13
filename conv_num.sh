#! /bin/sh
sed -e 's/\<0\>/zero/g' $1
sed -e 's/\<1\>/one/g' $1
sed -e 's/\<2\>/two/g' $1
sed -e 's/\<3\>/three/g' $1
sed -e 's/\<4\>/four/g' $1
sed -e 's/\<5\>/five/g' $1
sed -e 's/\<6\>/six/g' $1
sed -e 's/\<7\>/seven/g' $1
sed -e 's/\<8\>/eight/g' $1
sed -e 's/\<9\>/nine/g' $1
