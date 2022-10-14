#!/bin/bash

#pas1
awk -F "," ' NR > 1 { if (($1 ~ "ts[0-9]*") || ($1 ~ "tm[0-9]*")) print $0}' titles.cvs > prova.csv

#pas2
awk -F "," ' NR > 1 { if (($2 ~ /^[A-Z]/) || ($2 ~ /^[a-z]/) || ($2 ~ /^[0-9]/)) print $0}' prova.csv > prova2.csv

#pas3
awk -F "," ' NR > 1 { if (($3 ~ "MOVIE")) print $0}' prova2.csv > Movieq.csv
awk -F "," ' NR > 1 { if (($3 ~ "SHOW")) print $0}' prova2.csv > Showq.csv