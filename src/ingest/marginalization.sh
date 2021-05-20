#!/usr/bin/env bash

# wget -qO - http://www.conapo.gob.mx/work/models/CONAPO/Marginacion/Datos_Abiertos/Municipio/Base_Indice_de_marginacion_municipal_90-15.csv /data/raw/marginalization_tmp.csv
wget http://www.conapo.gob.mx/work/models/CONAPO/Marginacion/Datos_Abiertos/Municipio/Base_Indice_de_marginacion_municipal_90-15.csv -O /data/raw/marginalization_tmp.csv

iconv -f ISO-8859-1//TRANSLIT -t UTF-8 /data/raw/marginalization_tmp.csv | csvformat -D "|" > /data/raw/marginalization.csv

var="CVE_ENT|ENT|CVE_MUN|MUN|POB_TOT|VP|ANALF|SPRIM|OVSDE|OVSEE|OVSAE|VHAC|OVPT|PL<5000|PO2SM|OVSD|OVSDSE|IM|GM|IND0A100|LUG_NAC|LUGAR_EST|YEAR"

awk -i inplace '$0 = NR==1 ? replace : $0' replace="$var" /data/raw/marginalization.csv

sed -i 's/-//g' /data/raw/marginalization.csv
sed -i 's/| /|/g' /data/raw/marginalization.csv
sed  -i 's/\s*|/|/g' /data/raw/marginalization.csv

mv /data/raw/marginalization.csv /data/clean/marginalization.csv
csvsql -d "|" /data/clean/marginalization.csv > /data/clean/marginalization.sql

rm /data/raw/*
