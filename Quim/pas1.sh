#!/bin/bash

awk -F "," ' NR > 1 { if (($1 ~ "ts[0-9]*") || ($1 ~ "tm[0-9]*")) print $0}' titles.cvs > prova.csv
