#!/usr/bin/env bash

wget http://www.conapo.gob.mx/work/models/CONAPO/Marginacion/Datos_Abiertos/Municipio/Base_Indice_de_marginacion_municipal_90-15.csv -P ../data/

var="CVE_ENT,ENT,CVE_MUN,MUN,POB_TOT,VP,ANALF,SPRIM,OVSDE,OVSEE,OVSAE,VHAC,OVPT,PL<5000,PO2SM,OVSD,OVSDSE,IM,GM,IND0A100,LUG_NAC,LUGAR_EST,YEAR"

awk -i inplace '$0 = NR==1 ? replace : $0' replace="$var" ../data/Base_Indice_de_marginacion_municipal_90-15.csv

sed -i 's/-//g' ../data/Base_Indice_de_marginacion_municipal_90-15.csv