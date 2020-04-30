#!/usr/bin/env python

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.docker_operator import DockerOperator
from airflow.operators.python_operator import PythonOperator
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
        command='/src/indigenous_language.sh ', \
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


conapo_ingest >> indigenous_ingest >> marginalization_ingest >> schools_ingest >> geoms_ingest
