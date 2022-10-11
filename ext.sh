#! /bin/bash

#fem servir la comanda "sed" per tal d'elimnar totes les rows que continguin
#el text MOVIE i SHOW del fitxer csv.

# sed -i '/MOVIE/d' ShowData.csv #borrem pelis i ens quedem amb les series
# sed -i '/SHOW/d' MovieData.csv #borrem series i ens quedem amb pelis

# awk -F "," ' NR > 1 { if ($1 ~ "ts[0-9]*") print $0}' ShowData.csv > ShowData2.csv
# awk -F "," ' NR > 1 { if ($1 ~ "ts[0-9]*") print $0}' MovieData.csv > MovieData2.csv

awk -F "," ' NR > 1 { if (($2 !~ /^[A-Z]/) && ($2 !~ /^[a-z]/) && ($2 !~ /^[0-9]/) && ($2 !~ /^ /)) print $0}' ShowData2.csv  > asdf.csv 
