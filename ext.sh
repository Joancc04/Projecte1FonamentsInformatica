#! /bin/bash

./elim.sh
echo Creant arxius de dades...
touch Shows.csv
touch Movies.csv
touch Debris.csv
touch Debrist.csv


# sed -i '/MOVIE/d' ShowData.csv 
# sed -i '/SHOW/d' MovieData.csv 
# echo Netejant dades...



echo Classificant i netejant dades...
#trasllat de les dades útils
awk -F "," ' NR > 1 { if (($1 ~ "ts[0-9]") && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/)) ) print $0}' RawData.csv > Shows.csv
awk -F "," ' NR > 1 { if (($1 ~ "tm[0-9]") && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/)) ) print $0}' RawData.csv > Movies.csv



#trasllat i eliminat de les dades inservibles
awk -F "," ' NR > 1 { if ((($1 !~ "tm[0-9]") && ($1 !~ "ts[0-9]")) || (($2 !~ /^[A-Z]/) && ($2 !~ /^[0-9]/))) print $0}' RawData.csv  > Debris.csv 
awk -F "," ' NR > 1 { if (($1 !~ "tm[0-9]") && ($1 !~ "ts[0-9]") && ($1 !~ ",")) print $0}' RawData.csv  > Debrist.csv 
sed -i '/",,,,,,,,,,,,,,"/d' Debrist.csv

echo Finalitzat!
echo
awk 'END{ print NR, "línies eliminades degut a id errònies"}' Debrist.csv
awk 'END{print NR, "línies eliminades en total"}' Debris.csv
echo
awk 'END{print NR, "línies de pel·lícules"}' Movies.csv
awk 'END{print NR, "línies de series"}' Shows.csv
echo
awk 'END{print NR, "línies totals en el fitxer de dades original"}' RawData.csv


