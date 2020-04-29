#!/usr/bin/env bash

wget -O ../data/conapo_1.rar http://www.conapo.gob.mx/work/models/CONAPO/Datos_Abiertos/Proyecciones2018/base_municipios_final_datos_01.rar
wget -O ../data/conapo_2.rar http://www.conapo.gob.mx/work/models/CONAPO/Datos_Abiertos/Proyecciones2018/base_municipios_final_datos_02.rar

unrar x ../data/conapo_1.rar ../data/
unrar x ../data/conapo_2.rar ../data/

newline="CLAVE,CLAVE_ENT,NOM_ENT,MUN,SEXO,ANO,EDAD_QUIN,POB"

cat ../data/base_municipios_final_datos_01.csv | sed '1d' | sed '1i RENGLON,CLAVE,CLAVE_ENT,NOM_ENT,MUN,SEXO,ANO,EDAD_QUIN,POB' | cut -d"," -f2- > ../data/conapo_1.csv

cat ../data/base_municipios_final_datos_02.csv | sed '1d' |  cut -d"," -f2- > ../data/conapo_2.csv

cat ../data/conapo_1.csv ../data/conapo_2.csv > ../data/conapo.csv

rm ../data/conapo_1.rar ../data/conapo_2.rar\
    ../data/base_municipios_final_datos_02.csv\
    ../data/base_municipios_final_datos_01.csv ../data/conapo_1.csv ../data/conapo_2.csv