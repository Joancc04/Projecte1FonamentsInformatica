#! /bin/bash

./elim.sh
echo Creant arxius de dades...
touch Shows.csv  #arxiu amb dades netes de shows
touch Movies.csv #arxiu amb dades netes de pelis
touch Debris.csv #debris total (contador)
touch Debrisid.csv #debris ids (contador)
touch Debrisc.csv #debris columnes 11 - 15 (contador)


# sed -i '/MOVIE/d' ShowData.csv 
# sed -i '/SHOW/d' MovieData.csv 
# echo Netejant dades...

#trasllat i dividit de les dades útils
echo Classificant i netejant dades...
awk -F "," ' NR > 1 { if ( (($1 ~ "ts[0-9]") && ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 != "")  )    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > Shows.csv
awk -F "," ' NR > 1 { if ( (($1 ~ "tm[0-9]") && ( ($11 != "") && ($12 != "") && ($13 != "") && ($14 != "") && ($15 != "")  )    ) && (($2 ~ /^[A-Z]/) || ($2 ~ /^[0-9]/))) print $0}' RawData.csv > Movies.csv


#eliminat de les dades inservibles
awk -F "," ' NR > 1 { if (     (($1 !~ "ts[0-9]") && ($1 !~ "tm[0-9]"))    ||     (($2 !~ /^[A-Z]/) && ($2 !~ /^[0-9]/))    ||    (($11 == "") || ($12 == "") || ($13 == "") || ($14 == "") || ($15 == ""))      ) print $0}' RawData.csv  > Debris.csv 
awk -F "," ' NR > 1 { if (($1 !~ "tm[0-9]") && ($1 !~ "ts[0-9]") && ($1 !~ ",")) print $0}' RawData.csv  > Debrisid.csv 
awk -F "," ' NR > 1 { if ( (($1 ~ "ts[0-9]") || ($1 ~ "ts[0-9]")) && ( ($11 == "") || ($12 == "") || ($13 == "") || ($14 == "") || ($15 == "")  )) print $0}' RawData.csv > Debrisc.csv
sed -i '/",,,,,,,,,,,,,,"/d' Debrisid.csv


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


