#!/usr/bin/env python

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.docker_operator import DockerOperator
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago

default_args = {
        'owner': 'airflow',
        'depends_on_past': False,
        # If we want to select a specific launch date
        # 'start_date': datetime(2020,4,29),
        'start_date': days_ago(2),
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
    schedule_interval=timedelta(days=1),
#     This can also be a common cron job
#     schedule_interval= '*/5 * * * *'
)

conapo_ingest = DockerOperator(
        task_id='conapo',
        image='ingest',
        command='/src/conapo.sh', \
        dag = dag)

indigenous_ingest = BashOperator(
        task_id='indigenous',
        bash_command='docker run \
                -v $(pwd)/data/:/data\
                -v $(pwd)/src/ingest/:/src\
                        ingest /src/indigenous_language.sh', \
        dag = dag)

marginalization_ingest = BashOperator(
        task_id='marginalization',
        bash_command='docker run \
                -v $(pwd)/data/:/data\
                -v $(pwd)/src/ingest/:/src\
                        ingest /src/marginalization.sh', \
        dag = dag)

schools_ingest = BashOperator(
        task_id='schools',
        bash_command='docker run \
                -v $(pwd)/data/:/data\
                -v $(pwd)/src/ingest/:/src\
                        ingest /src/marginalization.sh', \
        dag = dag)

geoms_ingest = BashOperator(
        task_id='geoms',
        bash_command='docker run \
                -v $(pwd)/data/:/data\
                -v $(pwd)/src/ingest/:/src\
                        ingest /src/marginalization.sh', \
        dag = dag)


conapo_ingest >> indigenous_ingest >> marginalization_ingest >> schools_ingest >> geoms_ingest
