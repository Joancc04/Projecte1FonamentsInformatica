#! /bin/bash

#fem servir la comanda "sed" per tal d'elimnar totes les rows que continguin
#el text MOVIE i SHOW del fitxer csv.

sed -i '/MOVIE/d' MovieData.csv #borrem pelis i ens quedem amb les series
sed -i '/SHOW/d' ShowData.csv #borrem series i ens quedem amb pelis