#!/bin/bash

awk -F "," ' NR > 1 { if (($2 ~ /^[A-Z]/) || ($2 ~ /^[a-z]/) || ($2 ~ /^[0-9]/)) print $0}' prova.csv > prova2.csv
