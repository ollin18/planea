#!/usr/bin/env bash

while [ ! -e /edges/list/ingest.done ]
do
    sleep 30
done

./create_db.sh

/var/lib/neo4j/bin/neo4j console
