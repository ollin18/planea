#!/usr/bin/env bash

wget -O ../data/centros_escolares.zip http://9f0fda65d2ce0b27aaf2-105ac619070a816e0b7aa45dafa2da41.r45.cf1.rackcdn.com/cemabe/archivos_csv/tr_centros.csv.zip

wget -O ../data/conafe.zip http://9f0fda65d2ce0b27aaf2-105ac619070a816e0b7aa45dafa2da41.r45.cf1.rackcdn.com/cemabe/archivos_csv/tr_conafe.csv.zip

wget -O ../data/inmuebles.zip http://9f0fda65d2ce0b27aaf2-105ac619070a816e0b7aa45dafa2da41.r45.cf1.rackcdn.com/cemabe/archivos_csv/tr_inmuebles.csv.zip

unzip ../data/centros_escolares.zip -d ../data/
unzip ../data/conafe.zip -d ../data/
unzip ../data/inmuebles.zip -d ../data/