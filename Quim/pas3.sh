#!/bin/bash

awk -F "," ' NR > 1 { if (($3 ~ "MOVIE")) print $0}' prova2.csv > Movieq.csv
awk -F "," ' NR > 1 { if (($3 ~ "SHOW")) print $0}' prova2.csv > Showq.csv
#sed -i '/MOVIE/d' prova.csv>Showq.csv
#sed -i '/SHOW/d' prova.csv>Movieq.csv