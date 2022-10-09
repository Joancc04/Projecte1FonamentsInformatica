#! /bin/bash

OLDIFS=$IFS
IFS=","

echo "número de pel·lícules:"
grep -c MOVIE MovieData.csv

echo "número de series:"
grep -c SHOW ShowData.csv

#posant com a terme "tm" comprovem que el número és més gran, probablement degut a 
#les séries i pel·lícules que continguin "tm" les quals també han sigut afegides

IFS=$OLDIFS
