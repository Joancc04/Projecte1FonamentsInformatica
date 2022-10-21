#! /bin/bash

#funció eliminar dades
elim () {
    rm Shows.csv
    rm Movies.csv
    rm Debris.csv
    rm Debrisid.csv
    rm Debrisc.csv
    rm aux.csv
    rm MS.csv
}

echo "Tens dades anteriors? (S/n)"
read a 

if [ $a == "S" ];
then
    echo "S'han borrat les dades anteriors, procedim a substituir-les."
    elim
fi


echo Creant arxius de dades...
touch Shows.csv  #arxiu amb dades netes de shows
touch Movies.csv #arxiu amb dades netes de pelis
touch Debris.csv #debris total (contador)
touch Debrisid.csv #debris ids (contador)
touch Debrisc.csv #debris columnes 11 - 15 (contador)
touch aux.csv
touch aux2.csv
touch MS.csv



# sed -i '/MOVIE/d' ShowData.csv 
# sed -i '/SHOW/d' MovieData.csv 
# echo Netejant dades...

# -F "," = IFS

#trasllat i dividit de les dades útils
echo Classificant i netejant dades...
awk -F "," ' NR > 1 { if ( (($1 ~ "ts[0-9]") && ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 ~ /^[0-9]/))    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > Shows.csv
awk -F "," ' NR > 1 { if ( (($1 ~ "tm[0-9]") && ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 ~ /^[0-9]/))    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > Movies.csv
awk -F "," ' NR > 1 { if ( ((($1 ~ "tm[0-9]") || ($1 ~ "ts[0-9]"))&& ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 ~ /^[0-9]/))    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > aux.csv
# awk -F "," '$16={printf "%s%f\n", $13/$14}' Movies.csv


#eliminat de les dades inservibles
awk -F "," ' NR > 1 { if (     (($1 !~ "ts[0-9]") && ($1 !~ "tm[0-9]"))    ||     ( ($2 !~ /^[A-Z]/) && ($2 !~ /^[0-9]/) )     ||     (($11 == "") || ($12 == "") || ($13 == "") || ($14 == "") || ($15 !~ /^[0-9]/) )      ) print $0}' RawData.csv  > Debris.csv 
awk -F "," ' NR > 1 { if (     (($1 ~ "ts[0-9]")  || ($1 ~ "tm[0-9]"))     &&     ( ($11 == "") || ($12 == "") || ($13 == "") || ($14 == "") || ($15 !~ /^[0-9]/) )      ) print $0}' RawData.csv > Debrisc.csv
awk -F "," ' NR > 1 { if (      ($1 !~ "tm[0-9]") && ($1 !~ "ts[0-9]")     &&     ($1 !~ ",")      ) print $0}' RawData.csv  > Debrisid.csv 
sed -i '/",,,,,,,,,,,,,,"/d' Debrisid.csv
#


#contados
echo Finalitzat!
echo
awk 'END{ print NR, "línies eliminades degut a id errònies"}' Debrisid.csv
awk 'END{print NR, "línies eliminades per espais en blanc:"}' Debrisc.csv
awk 'END{print NR, "línies eliminades en total"}' Debris.csv
echo
awk 'END{print NR, "línies de pel·lícules netes"}' Movies.csv
awk 'END{print NR, "línies de series netes"}' Shows.csv
echo
awk 'END{print NR, "línies totals en el fitxer de dades original"}' RawData.csv
echo
#NR = Number of Records

#$12 imdb score $13 imdb votes $14 tmdb popularitat $15 tmdb score
awk -F "," 'BEGIN{max1=0} { if($13 > max1) max1=$13} {print $0 "," $12*($13/max1)}' aux.csv > aux2.csv 
awk -F "," 'BEGIN{max1=0} { if($14 > max2) max2=$14} {print $0 "," $14*($15/max2)}' aux2.csv > MS.csv 
echo 
awk -F "," 'BEGIN{maxv=0} { if($13 > maxv) maxv=$13} END{print "El número més gran imdb_votes és:", maxv}' aux.csv #troba el màxim de la columna 13
awk -F "," 'BEGIN{maxp=0} { if($14 > maxp) maxp=$14} END{print "El número més gran tmdb_popularity és:", maxp}' aux.csv #troba el màxim de la columna 14
echo 

sed -i 's/\"//g' MS.csv #borra totes les dobles comes del script, /g per incloure no només les del principi

awk -F "," 'BEGIN{a=0} { if ($12 > a && $3=="MOVIE") a=$12} END{print "La pel·lícula amb la millor puntuació imdb és:", a}' MS.csv
awk -F "," 'BEGIN{b=0} { if ($12 > b && $3=="SHOW") b=$12} END{print "La serie amb la millor puntuació imdb és:", b}' MS.csv
awk -F "," 'BEGIN{c=0} { if ($13 > c && $3=="MOVIE") c=$13} END{print "La pel·lícula més popular segons imdb és:", c}' MS.csv
awk -F "," 'BEGIN{d=0} { if ($13 > d && $3=="SHOW") d=$13} END{print "La serie més popular segons imdb és:", d}' MS.csv
awk -F "," 'BEGIN{e=0} { if ($16 > e && $3=="MOVIE") e=$16} END{print "La pel·lícula amb el millor coeficient Imdb és:", e}' MS.csv
awk -F "," 'BEGIN{f=0} { if ($16 > f && $3=="SHOW") f=$16} END{print "La serie amb el millor coeficient IMDB és:", f}' MS.csv


echo "Títols als documents? (S/n)"
read c
if [ $c == "S" ];
then
    # afegim els títols fora dels contadors per tal que no influeixin
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries, ,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' Movies.csv
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' Shows.csv
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' aux.csv
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' MS.csv

fi

echo "T'agradaria conservar les dades? (S/n)"
read b 
if [ $b != "S" ];
then
    elim
    echo "S'han borrat les dades"
fi
rm aux.csv
rm aux2.csv

