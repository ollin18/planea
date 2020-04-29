#! /usr/bin/env bash

export NODEH=/nodes/headers
export NODEL=/nodes/list
export EDGEH=/edges/headers
export EDGEL=/edges/list

/var/lib/neo4j/bin/neo4j-admin import --mode=csv --delimiter="|" \
	--ignore-duplicate-nodes=true \
    --database=migration.db \
	--nodes:Countries "$NODEH/countries.csv,$NODEL/countries.csv" \
	--nodes:Years "$NODEH/years.csv,$NODEL/years.csv" \
	--nodes:Location "$NODEH/location.csv,$NODEL/location.csv"\
	--relationships "$EDGEH/seekers.csv,$EDGEL/seekers.csv" \
	--relationships "$EDGEH/population.csv,$EDGEL/population.csv" \
	--relationships "$EDGEH/gdp.csv,$EDGEL/gdp.csv" \
	--relationships "$EDGEH/monthly.csv,$EDGEL/monthly.csv" \
	--relationships "$EDGEH/demo.csv,$EDGEL/demo.csv" \
	--relationships "$EDGEH/concern.csv,$EDGEL/concern.csv" \
	--relationships "$EDGEH/resettlement.csv,$EDGEL/resettlement.csv"

