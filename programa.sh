#! /bin/bash

_crearArxius () {
    echo "Creant arxius de dades..."
    touch Shows.csv  #arxiu amb dades netes de shows
    touch Movies.csv #arxiu amb dades netes de pelis
    touch MiS.csv #arxiu amb pel·lícules i series (Movies&Shows)

    touch Debris.csv #debris total (contador)
    touch Debrisid.csv #debris id's (contador)
    touch Debrisc.csv #debris columnes 12 - 15 (contador)
    touch aux1.csv #arxiu auxiliar1
    touch aux2.csv #arxiu auxiliar2
}

_elimData () {
    rm Shows.csv
    rm Movies.csv
    rm MiS.csv #Movies i Shows
    echo "S'han borrat les dades"
}

_elimAux() {
    rm aux1.csv
    rm aux2.csv
    rm Debris.csv
    rm Debrisc.csv
    rm Debrisid.csv
}

_saltLinia () {
    echo
    echo
}

#amb la comanda sed -i, i posant com a primers caràcters "1i" aconseguim enganxar les línies següents als princips dels arxius de dades.
_titols() {
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries, ,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' Movies.csv
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' Shows.csv
    sed -i '1iid,title,type,description,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes,tmdb_popularity,tmdb_score,imdb_reliability,tmdb_reliability' MiS.csv
}



#Borrat dels arxius de dades anteriors en cas d'haver-les guardat al final del programa.
echo "Tens arxius de dades anteriors? (S/n)"
read a 
if [ $a == "S" ];
then
    _elimData
fi
_crearArxius



#Filtrat de les dades útils, i divisió d'aquestes en diferents arxius.
echo "Classificant i netejant dades..."
awk -F "," ' NR > 1 { if ( (($1 ~ "ts[0-9]") && ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 ~ /^[0-9]/))    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' titles.cvs > Shows.csv
awk -F "," ' NR > 1 { if ( (($1 ~ "tm[0-9]") && ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 ~ /^[0-9]/))    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' titles.cvs > Movies.csv
awk -F "," ' NR > 1 { if ( ((($1 ~ "tm[0-9]") || ($1 ~ "ts[0-9]"))&& ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 ~ /^[0-9]/))    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' titles.cvs > aux1.csv

#Transportat de les dades inservibles a arxius auxiliars per tal de contar-les després.
awk -F "," ' NR > 1 { if (     (($1 !~ "ts[0-9]") && ($1 !~ "tm[0-9]"))    ||     ( ($2 !~ /^[A-Z]/) && ($2 !~ /^[0-9]/) )     ||     (($11 == "") || ($12 == "") || ($13 == "") || ($14 == "") || ($15 !~ /^[0-9]/) )      ) print $0}' titles.cvs  > Debris.csv 
awk -F "," ' NR > 1 { if (     (($1 ~ "ts[0-9]")  || ($1 ~ "tm[0-9]"))     &&     ( ($11 == "") || ($12 == "") || ($13 == "") || ($14 == "") || ($15 !~ /^[0-9]/) )      ) print $0}' titles.cvs > Debrisc.csv
awk -F "," ' NR > 1 { if (      ($1 !~ "tm[0-9]") && ($1 !~ "ts[0-9]")     &&     ($1 !~ ",")      ) print $0}' titles.cvs  > Debrisid.csv 
sed -i '/",,,,,,,,,,,,,,"/d' Debrisid.csv #eliminem els espais en blanc d'aquest arxiu en específic per tal de que no interfereixin amb les dades eliminades degut a id errònies.



#Contadors. Per tal de dir quantes linies s'han eliminat en cada procés hem enginyat aquest mètode. Copiar les dades inservibles a un document per separat,
#i després contar quantes línies hi ha en aquell document en especific per tal d'obtenir el nombre de línies defectuoses en cada cas.
echo "Finalitzat!"
echo
awk 'END{ print NR, "línies eliminades degut a id errònies"}' Debrisid.csv
awk 'END{print NR, "línies eliminades per espais en blanc:"}' Debrisc.csv
awk 'END{print NR, "línies eliminades en total"}' Debris.csv
echo
awk 'END{print NR, "línies de pel·lícules netes"}' Movies.csv
awk 'END{print NR, "línies de series netes"}' Shows.csv
echo
awk 'END{print NR, "línies totals en el fitxer de dades original"}' titles.cvs
#NR --> Number of Records (rows)

_saltLinia

#$12 --> imdb score     $13 --> imdb votes      $14 --> tmdb popularitat        $15 --> tmdb score
#Càlcul dels coeficients, i conseqüent print en cada una de les seves línies.
awk -F "," 'BEGIN{max1=0} { if($13 > max1) max1=$13} {print $0 "," $12*($13/max1)}' aux1.csv > aux2.csv 
awk -F "," 'BEGIN{max1=0} { if($14 > max2) max2=$14} {print $0 "," $15*($14/max2)}' aux2.csv > MiS.csv 

awk -F "," 'BEGIN{maxv=0} { if($13 > maxv) maxv=$13} END{print "El número més gran imdb_votes és:", maxv}' aux1.csv #troba el màxim de la columna 13
awk -F "," 'BEGIN{maxp=0} { if($14 > maxp) maxp=$14} END{print "El número més gran tmdb_popularity és:", maxp}' aux1.csv #troba el màxim de la columna 14

_saltLinia

#posem també els coeficients IMDB i TMDB als arxius corresponents de Movies i Shows.
awk -F "," '{ if($3=="MOVIE") print $0}' MiS.csv > Movies.csv
awk -F "," '{ if($3=="SHOW") print $0}' MiS.csv > Shows.csv



#borra totes les cometes " per tal de que no hi hagin errors en la seva representació.  ** /g per borrar no només les " del principi de cada línia
sed -i 's/\"//g' MiS.csv 
sed -i 's/\"//g' Movies.csv
sed -i 's/\"//g' Shows.csv



echo "Imdb:"
awk -F "," 'BEGIN{id="";title="";ctry="";sc=0} { if ($12 > sc && $3=="MOVIE") {sc=$12 ; id=$1 ; ctry=$9 ; title=$2}} END{print "Pel·lícula amb millor puntuació IMDB:", id, title, ctry, sc}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";sc=0} { if ($12 > sc && $3=="SHOW") {sc=$12 ; id=$1 ; ctry=$9 ; title=$2}} END{print "Serie amb millor puntuació IMDB:", id, title, ctry, sc}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";ivotes=0} { if ($13 > ivotes && $3=="MOVIE") {ivotes=$13 ; id=$1 ; title=$2 ; ctry=$9}} END{print "Pel·lícula més popular segons IMDB:", id, title, ctry, ivotes}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";ivotes=0;isc=0} { if ($13 > ivotes && $3=="SHOW") {ivotes=$13 ; id=$1 ; title=$2 ; ctry=$9; isc=$12}} END{print "Serie més popular segons IMDB:",  id, title, ctry, isc}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";coe=0;isc=0} { if ($16 >= coe && $3=="MOVIE") {coe=$16 ; id=$1 ; title=$2 ; ctry=$9 ; isc=$12}} END{print "Pel·lícula amb el millor coeficient IMDB:", id, title, ctry, coe}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";coe=0;isc=0} { if ($16 >= coe && $3=="SHOW") {coe=$16 ; id=$1 ; title=$2 ; ctry=$9 ; isc=$12}} END{print "Serie amb el millor coeficient IMDB:", id, title, ctry, coe}' MiS.csv
echo
echo "Tmdb:"
awk -F "," 'BEGIN{id="";title="";ctry="";sc=0} { if ($15 > sc && $3=="MOVIE") {sc=$15 ; id=$1 ; ctry=$9 ; title=$2}} END{print "Pel·lícula amb millor puntuació TMDB:", id, title, ctry, sc}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";sc=0} { if ($15 > sc && $3=="SHOW") {sc=$15 ; id=$1 ; ctry=$9 ; title=$2}} END{print "Serie amb millor puntuació TMDB:", id, title, ctry, sc}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";tmp=0} { if ($14 > tmp && $3=="MOVIE") {tmp=$14 ; id=$1 ; title=$2 ; ctry=$9}} END{print "Pel·lícula més popular segons TMDB:", id, title, ctry, tmp}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";tmp=0;isc=0} { if ($14 > tmp && $3=="SHOW") {tmp=$14 ; id=$1 ; title=$2 ; ctry=$9; isc=$12}} END{print "Serie més popular segons TMDB:",  id, title, ctry, tmp}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";coe=0;isc=0} { if ($17 > coe && $3=="MOVIE") {coe=$17 ; id=$1 ; title=$2 ; ctry=$9 ; isc=$12}} END{print "Pel·lícula amb el millor coeficient TMDB:", id, title, ctry, coe}' MiS.csv
awk -F "," 'BEGIN{id="";title="";ctry="";coe=0} { if ($17 > coe && $3=="SHOW") {coe=$17 ; id=$1 ; title=$2 ; ctry=$9}} END{print "Serie amb el millor coeficient TMDB:", id, title, ctry, coe}' MiS.csv



#afegim títols als documents i eliminen els arxius de dades auxiliars
_titols
_elimAux

_saltLinia

echo "T'agradaria conservar les dades? (S/n)"
read b 
if [ $b != "S" ];
then
    _elimData
fi



#Comandes que vàrem utilitzar al principi per afegir o no títols als document.
# echo "Títols als documents? (S/n)"
# read c
# if [ $c == "S" ];
# then
#     # afegim els títols fora dels contadors per tal que no influeixin
#    _titols
# fi