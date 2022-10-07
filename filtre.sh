#!/bin/bash

OLDIFS=$IFS
IFS=","

while read id type title director 
do
	echo -e "\e[1;35m$user \
	================================\e[0m\n\
	
	Id    :\t $id\n\
	Tipus :\t $type\n\
	Títol :\t $title\n"
	
done<titles.cvs
IFS=$OLDIFS

