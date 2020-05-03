#!/usr/bin/env bash

# Collect the data for CEMABE (Censo de Escuelas, Maestros y Alumnos de Educación Básica y Especial) from INEGI
wget -O /data/raw/centros_escolares.zip http://9f0fda65d2ce0b27aaf2-105ac619070a816e0b7aa45dafa2da41.r45.cf1.rackcdn.com/cemabe/archivos_csv/tr_centros.csv.zip
wget -O /data/raw/conafe.zip http://9f0fda65d2ce0b27aaf2-105ac619070a816e0b7aa45dafa2da41.r45.cf1.rackcdn.com/cemabe/archivos_csv/tr_conafe.csv.zip
wget -O /data/raw/inmuebles.zip http://9f0fda65d2ce0b27aaf2-105ac619070a816e0b7aa45dafa2da41.r45.cf1.rackcdn.com/cemabe/archivos_csv/tr_inmuebles.csv.zip

unzip /data/raw/centros_escolares.zip -d /data/raw/
unzip /data/raw/conafe.zip -d /data/raw/
unzip /data/raw/inmuebles.zip -d /data/raw/

iconv -f ISO-8859-1//TRANSLIT -t UTF-8 /data/raw/tr_centros.csv > /data/raw/utf_tr_centros.csv
iconv -f ISO-8859-1//TRANSLIT -t UTF-8 /data/raw/tr_conafe.csv > /data/raw/utf_tr_conafe.csv
iconv -f ISO-8859-1//TRANSLIT -t UTF-8 /data/raw/tr_inmuebles.csv > /data/raw/utf_tr_inmuebles.csv

cat /data/raw/utf_tr_centros.csv | csvformat -d ";" -D "|" > /data/clean/tr_centros.csv
cat /data/raw/utf_tr_conafe.csv | csvformat -d ";" -D "|" > /data/clean/tr_conafe.csv
cat /data/raw/utf_tr_inmuebles.csv | csvformat -d ";" -D "|" > /data/clean/tr_inmuebles.csv

csvsql -d "|" /data/clean/tr_centros.csv > /data/sql/tr_centros.sql
csvsql -d "|" /data/clean/tr_conafe.csv > /data/sql/tr_conafe.sql
csvsql -d "|" /data/clean/tr_inmuebles.csv > /data/sql/tr_inmuebles.sql

rm /data/raw/*
