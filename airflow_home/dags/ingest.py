#!/usr/bin/env python

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.docker.operators.docker import DockerOperator
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
import os

wd = os.getcwd()

default_args = {
        'owner': 'airflow',
        'depends_on_past': False,
        # If we want to select a specific launch date
        # 'start_date': datetime(2020,4,29),
        # 'start_date': '2020-01-01',
        'start_date': days_ago(7),
        'email': ['olangle@uvm.edu'],
        'email_on_failure': False,
        'email_on_retry': False,
        'concurrency': 1,
        'retry_delay': timedelta(minutes=5),
        'retries': 0,
        }

dag = DAG(
    'ingest',
    default_args=default_args,
    description='Ingestion of the required files',
    schedule_interval=timedelta(days=10),
#     This can also be a common cron job
#     schedule_interval= '*/5 * * * *'
)

planea_ingest = DockerOperator(
        task_id='planea',
        image='ingest',
        volumes=[wd+'/data/:/data',wd+'/src/ingest/:/src'],
        command='/src/planea.py ', \
        dag = dag)

conapo_ingest = DockerOperator(
        task_id='conapo',
        image='ingest',
        volumes=[wd+'/data/:/data',wd+'/src/ingest/:/src'],
        command='/src/conapo.sh ', \
        dag = dag)

indigenous_ingest = DockerOperator(
        task_id='indigenous',
        image='ingest',
        volumes=[wd+'/data/:/data',wd+'/src/ingest/:/src'],
        command='/src/indigenous_language.py ', \
        dag = dag)

marginalization_ingest = DockerOperator(
        task_id='marginalization',
        image='ingest',
        volumes=[wd+'/data/:/data',wd+'/src/ingest/:/src'],
        command='/src/marginalization.sh ', \
        dag = dag)

schools_ingest = DockerOperator(
        task_id='schools',
        image='ingest',
        volumes=[wd+'/data/:/data',wd+'/src/ingest/:/src'],
        command='/src/schools.sh ', \
        dag = dag)

geoms_ingest = DockerOperator(
        task_id='geoms',
        image='ingest',
        volumes=[wd+'/data/:/data',wd+'/src/ingest/:/src'],
        command='/src/geoms.sh ', \
        dag = dag)

planea_schemas = BashOperator(
        task_id='planea_schemas',
        bash_command="docker cp "+wd+"/data/sql/planea.sql planeadb:/var/lib/postgresql/data/planea.sql &&\
                docker exec -u postgres planeadb psql planea planea -f /var/lib/postgresql/data/planea.sql &&\
                cat "+wd+"/data/clean/planea.csv| docker exec -i planeadb psql -U planea \
                        -c \"copy planea from stdin with (format csv, DELIMITER '|', header true);\"",
        dag = dag)

conapo_schemas = BashOperator(
        task_id='conapo_schemas',
        bash_command="docker cp "+wd+"/data/sql/conapo.sql planeadb:/var/lib/postgresql/data/conapo.sql &&\
                docker exec -u postgres planeadb psql planea planea -f /var/lib/postgresql/data/conapo.sql &&\
                cat "+wd+"/data/clean/conapo.csv| docker exec -i planeadb psql -U planea \
                        -c \"copy conapo from stdin with (format csv, DELIMITER '|', header true);\"",
        dag = dag)

indigenous_schemas = BashOperator(
        task_id='indigenous_schemas',
        bash_command="docker cp "+wd+"/data/sql/indigenous_language.sql planeadb:/var/lib/postgresql/data/indigenous_language.sql &&\
                docker exec -u postgres planeadb psql planea planea -f /var/lib/postgresql/data/indigenous_language.sql &&\
                cat "+wd+"/data/clean/indigenous_language.csv| docker exec -i planeadb psql -U planea \
                        -c \"copy indigenous_language from stdin with (format csv, DELIMITER '|', header true);\"",
        dag = dag)

marginalization_schemas = BashOperator(
        task_id='marginalization_schemas',
        bash_command="docker cp "+wd+"/data/sql/marginalization.sql planeadb:/var/lib/postgresql/data/marginalization.sql &&\
                docker exec -u postgres planeadb psql planea planea -f /var/lib/postgresql/data/marginalization.sql &&\
                cat "+wd+"/data/clean/marginalization.csv| docker exec -i planeadb psql -U planea \
                        -c \"copy marginalization from stdin with (format csv, DELIMITER '|', header true);\"",
        dag = dag)

geoms_schemas = BashOperator(
        task_id='geoms_schemas',
        bash_command="docker cp "+wd+"/data/sql/geom_muni.sql planeadb:/var/lib/postgresql/data/geom_muni.sql &&\
                docker exec -u postgres planeadb psql planea planea -f /var/lib/postgresql/data/geom_muni.sql &&\
                cat "+wd+"/data/clean/geom_muni.csv| docker exec -i planeadb psql -U planea \
                        -c \"copy geom_muni from stdin with (format csv, DELIMITER '|', header true);\"",
        dag = dag)

conapo_ingest >> conapo_schemas
indigenous_ingest >> indigenous_schemas
(planea_ingest, marginalization_ingest,schools_ingest) >> planea_schemas >> marginalization_schemas
geoms_ingest >> geoms_schemas
