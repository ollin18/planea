#!/usr/bin/env bash

wget -qO - http://www.cdi.gob.mx/datosabiertos/2010/pob-indi-mpio-2010.csv | csvformat -D "|" > /data/clean/indigenous_language.csv

wget -O /data/dics/indigenous_language.xlsx http://www.cdi.gob.mx/datosabiertos/2010/dd-pob-indi-mpio-2010.xlsx