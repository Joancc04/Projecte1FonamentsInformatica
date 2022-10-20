#! /bin/bash

#funció eliminar dades
elim () {
    rm Shows.csv
    rm Movies.csv
    rm Debris.csv
    rm Debrisid.csv
    rm Debrisc.csv
    rm MS.csv
    rm prova.csv
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
touch MS.csv
touch prova.csv



# sed -i '/MOVIE/d' ShowData.csv 
# sed -i '/SHOW/d' MovieData.csv 
# echo Netejant dades...

# -F "," = IFS

#trasllat i dividit de les dades útils
echo Classificant i netejant dades...
awk -F "," ' NR > 1 { if ( (($1 ~ "ts[0-9]") && ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 ~ /^[0-9]/))    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > Shows.csv
awk -F "," ' NR > 1 { if ( (($1 ~ "tm[0-9]") && ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 ~ /^[0-9]/))    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > Movies.csv
awk -F "," ' NR > 1 { if ( ((($1 ~ "tm[0-9]") || ($1 ~ "ts[0-9]"))&& ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 ~ /^[0-9]/))    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > MS.csv
# awk -F "," '$16={printf "%s%f\n", $13/$14}' Movies.csv


#eliminat de les dades inservibles
awk -F "," ' NR > 1 { if (     (($1 !~ "ts[0-9]") && ($1 !~ "tm[0-9]"))    ||     (($2 !~ /^[A-Z]/) && ($2 !~ /^[0-9]/))    ||    (($11 == "") || ($12 == "") || ($13 == "") || ($14 == "") || ($15 !~ /^[0-9]/))      ) print $0}' RawData.csv  > Debris.csv 
awk -F "," ' NR > 1 { if (($1 !~ "tm[0-9]") && ($1 !~ "ts[0-9]") && ($1 !~ ",")) print $0}' RawData.csv  > Debrisid.csv 
awk -F "," ' NR > 1 { if ( (($1 ~ "ts[0-9]") || ($1 ~ "tm[0-9]")) && ( ($11 == "") || ($12 == "") || ($13 == "") || ($14 == "") || ($15 !~ /^[0-9]/)  )) print $0}' RawData.csv > Debrisc.csv
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


awk -F "," 'BEGIN{maxv=0} { if($13 > maxv) maxv=$13} END{print "El número més gran imdb_votes és:", maxv}' MS.csv #troba el màxim de la columna 13
awk -F "," 'BEGIN{maxp=0} { if($14 > maxp) maxp=$14} END{print "El número més gran tmdb_popularity és:", maxp}' MS.csv #troba el màxim de la columna 14


awk -F "," '{print $0, $12*($13/(2268288))}' MS.csv > prova.csv
# paste MS.csv prova.csv | awk '{print $6, $NF}' > test3.txt
echo "Títols als documents? (S/n)"
read c


if [ $c != "S" ];
then
    # afegim els títols fora dels contadors per tal que no influeixin
    sed -i '1i"id,title,type,description,release_year,age_certification,runtime,genres,production_countries, ,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability"' Movies.csv
    sed -i '1i"id,title,type,description,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability"' Shows.csv
    sed -i '1i"id,title,type,description,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability"' MS.csv
fi

echo "T'agradaria conservar les dades? (S/n)"
read b 
if [ $b != "S" ];
then
    elim
    echo "S'han borrat les dades"
fi


