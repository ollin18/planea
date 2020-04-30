#!/usr/bin/env bash
################################################
# Script para descargar geometrías de municipios de Inegi
# We need gsutil because it's on GCP as I didn't want to
# download the gigantic shp file
################################################

wget -O /data/clean/geom_muni.csv https://storage.googleapis.com/planea-test-2018/data/geom_muni.csv