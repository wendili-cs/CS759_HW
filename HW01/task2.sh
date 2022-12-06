#!/usr/bin/env bash

echo -e "\n=====Q (a)====="
cd somedir

echo -e "\n=====Q (b)====="
cat sometext.txt

echo -e "\n=====Q (c)====="
head -n 5 sometext.txt

echo -e "\n=====Q (d)====="
tail -n 5 *.txt

echo -e "\n=====Q (e)====="
for i in {0..6}
do
    printf "$i\n"
done