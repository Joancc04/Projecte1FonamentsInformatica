#! /bin/bash

./elim.sh
echo Creant arxius de dades...
touch ShowData.csv
touch MovieData.csv
touch Debris.csv


# sed -i '/MOVIE/d' ShowData.csv 
# sed -i '/SHOW/d' MovieData.csv 
# echo Netejant dades...



echo Classificant i netejant dades...
awk -F "," ' NR > 1 { if (($1 ~ "ts[0-9]") && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > ShowData.csv
awk -F "," ' NR > 1 { if (($1 ~ "tm[0-9]") && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > MovieData.csv

awk -F "," ' NR > 1 { if ((($1 !~ "tm[0-9]") && ($1 !~ "ts[0-9]")) || (($2 !~ /^[A-Z]/) && ($2 !~ /^[0-9]/))) print $0}' RawData.csv  > Debris.csv 


# awk -F "," ' NR > 1 { if (($1 !~ "tm[0-9]*") || ($2 !~ /^[A-Z]/) || ($2 !~ /^[a-z]/) || ($2 !~ /^[0-9]/) || ($2 !~ /^ /)) print $0}' MovieData.csv  > DebrisM.csv 


echo En total shan eliminat
awk 'END{print NR}' Debris.csv
echo linies

echo I queden netes:
awk 'END{print NR}' MovieData.csv
echo pel·lícules i
awk 'END{print NR}' ShowData.csv
echo series, dun total de:
awk 'END{print NR}' RawData.csv
echo linies

echo Finalitzat!