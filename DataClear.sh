#!/bin/bash

IFS="," #amb la variable IFS establim el elemnt que separa les columnes en el fitxer CSV

while read id type title director 
do
	
	echo -e "\e[1;35m$user \
	================================\e[0m\n\

	Id    :\t $id\n\
	Tipus :\t $type\n\
	Títol :\t $title\n"

done < <(tail -n +2 Movies.csv)
#fem servir "tail -n +2" per tal de que el programa no llegeixi la primera línia de l'arxiu csv, la qual conté el títol de cada columna.



