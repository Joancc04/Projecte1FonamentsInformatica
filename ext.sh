#! /bin/bash

#funció eliminar dades
elim () {
    rm Shows.csv
    rm Movies.csv
    rm Debris.csv
    rm Debrisid.csv
    rm Debrisc.csv
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
echo 
sed -i 's/\"//g' MS.csv #borra totes les dobles comes del script, /g per incloure no només les del principi
echo "Imdb:"
awk -F "," 'BEGIN{id="";title="";ctry="";sc=0} { if ($12 > sc && $3=="MOVIE") {sc=$12 ; id=$1 ; ctry=$9 ; title=$2}} END{print "Pel·lícula amb millor puntuació IMDB:", id, title, ctry, sc}' MS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";sc=0} { if ($12 > sc && $3=="SHOW") {sc=$12 ; id=$1 ; ctry=$9 ; title=$2}} END{print "Serie amb millor puntuació IMDB:", id, title, ctry, sc}' MS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";ivotes=0} { if ($13 > ivotes && $3=="MOVIE") {ivotes=$13 ; id=$1 ; title=$2 ; ctry=$9}} END{print "Pel·lícula més popular segons IMDB:", id, title, ctry, ivotes}' MS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";ivotes=0;isc=0} { if ($13 > ivotes && $3=="SHOW") {ivotes=$13 ; id=$1 ; title=$2 ; ctry=$9; isc=$12}} END{print "Serie més popular segons IMDB:",  id, title, ctry, isc}' MS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";coe=0;isc=0} { if ($16 >= coe && $3=="MOVIE") {coe=$16 ; id=$1 ; title=$2 ; ctry=$9 ; isc=$12}} END{print "Pel·lícula amb el millor coeficient IMDB:", id, title, ctry, coe}' MS.csv
echo
echo "Tmdb:"
awk -F "," 'BEGIN{id="";title="";ctry="";sc=0} { if ($15 > sc && $3=="MOVIE") {sc=$15 ; id=$1 ; ctry=$9 ; title=$2}} END{print "Pel·lícula amb millor puntuació TMDB:", id, title, ctry, sc}' MS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";sc=0} { if ($15 > sc && $3=="SHOW") {sc=$15 ; id=$1 ; ctry=$9 ; title=$2}} END{print "Serie amb millor puntuació TMDB:", id, title, ctry, sc}' MS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";tmp=0} { if ($14 > tmp && $3=="MOVIE") {tmp=$14 ; id=$1 ; title=$2 ; ctry=$9}} END{print "Pel·lícula més popular segons TMDB:", id, title, ctry, tmp}' MS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";tmp=0;isc=0} { if ($14 > tmp && $3=="SHOW") {tmp=$14 ; id=$1 ; title=$2 ; ctry=$9; isc=$12}} END{print "Serie més popular segons TMDB:",  id, title, ctry, tmp}' MS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";coe=0;isc=0} { if ($17 > coe && $3=="MOVIE") {coe=$17 ; id=$1 ; title=$2 ; ctry=$9 ; isc=$12}} END{print "Pel·lícula amb el millor coeficient TMDB:", id, title, ctry, coe}' MS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";coe=0} { if ($17 > coe && $3=="SHOW") {coe=$17 ; id=$1 ; title=$2 ; ctry=$9}} END{print "La serie amb el millor coeficient TMDB és:", id, title, ctry, coe}' MS.csv


rm aux.csv
rm aux2.csv

echo "Títols als documents? (S/n)"
read c
if [ $c == "S" ];
then
    # afegim els títols fora dels contadors per tal que no influeixin
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries, ,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' Movies.csv
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' Shows.csv
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' MS.csv

fi

echo "T'agradaria conservar les dades? (S/n)"
read b 
if [ $b != "S" ];
then
    elim
    echo "S'han borrat les dades"
fi


