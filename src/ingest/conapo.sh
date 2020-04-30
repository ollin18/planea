#!/usr/bin/env bash

wget -O /data/raw/conapo_1.rar http://www.conapo.gob.mx/work/models/CONAPO/Datos_Abiertos/Proyecciones2018/base_municipios_final_datos_01.rar
wget -O /data/raw/conapo_2.rar http://www.conapo.gob.mx/work/models/CONAPO/Datos_Abiertos/Proyecciones2018/base_municipios_final_datos_02.rar

unrar x /data/raw/conapo_1.rar /data/raw/
unrar x /data/raw/conapo_2.rar /data/raw/

newline="CLAVE,CLAVE_ENT,NOM_ENT,MUN,SEXO,ANO,EDAD_QUIN,POB"

cat /data/raw/base_municipios_final_datos_01.csv | sed '1d' | sed '1i RENGLON,CLAVE,CLAVE_ENT,NOM_ENT,MUN,SEXO,ANO,EDAD_QUIN,POB' | cut -d"," -f2- > /data/raw/conapo_1.csv

cat /data/raw/base_municipios_final_datos_02.csv | sed '1d' |  cut -d"," -f2- > /data/raw/conapo_2.csv

iconv -f ISO-8859-1//TRANSLIT -t UTF-8 /data/raw/conapo_1.csv > /data/raw/utf_conapo_1.csv
iconv -f ISO-8859-1//TRANSLIT -t UTF-8 /data/raw/conapo_2.csv > /data/raw/utf_conapo_2.csv

cat /data/raw/utf_conapo_1.csv /data/raw/utf_conapo_2.csv | csvformat -D "|" > /data/clean/conapo.csv

rm /data/raw/*