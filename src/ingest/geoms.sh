#!/usr/bin/env bash
################################################
# Script para descargar geometrías de municipios de Inegi
################################################

year=$1
# local_path=$2
# local_ingest_file=$3

if [ $year = '2018' ]; then
    cve=889463526636_s.zip
elif [ $year = '2017' ]; then
    cve=889463171829_s.zip
else
    echo 'url not defined for the selected year'
    exit 1
fi

mkdir /data/raw/$year $local_path/$year/temp /data/raw/$year/final

## Download geoms de inegi
wget "http://internet.contenidos.inegi.org.mx/contenidos/Productos/prod_serv/contenidos/espanol/bvinegi/productos/geografia/marcogeo/"$cve"" -O /data/raw/geom_inegi$year.zip

## Unzip folder principal
unzip -o /data/raw/geom_inegi$year.zip -d /data/raw/$year/

## Unzip folder por estado
for i in /data/raw/$year/*.zip; do
  filename=$(basename -- "$i")
  filename="${filename%.*}"
  mkdir $filename
  unzip "$i" -d  /data/raw/$year/$filename/
done

mv /data/raw/$year/*/*/*mun* /data/raw/$year/temp/
for i in /data/raw/$year/temp/*.shp; do
  filename=$(basename -- "$i")
  filename="${filename%.*}"
  ogr2ogr -f CSV -t_srs EPSG:4326 /data/raw/$year/final/$filename.csv $i  -lco GEOMETRY=AS_WKT
done

# Concatenar y guardar
nawk 'FNR==1 && NR!=1{next;}{print}'  /data/raw/$year/final/*.csv > /data/raw/$year/output.csv.file

# Cambiar formato
csvformat -D '|' -z 99999999999 /data/raw/$year/output.csv.file > /data/clean/geom_muni.csv
rm -Rf /data/raw/$year/