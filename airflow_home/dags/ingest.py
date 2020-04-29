#!/usr/bin/env python

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator

default_args = {
        'owner': 'airflow',
        'depends_on_past': False,
        'start_date': datetime(2020,4,29),
        'email_on_failure': False,
        'email_on_retry': False,
        'concurrency': 1,
        'retry_delay': timedelta(minutes=5),
        'retries': 0,
        }

dag = DAG('simple', default_args=default_args,
        schedule_interval= '*/5 * * * *'
        )

opr_ingest = BashOperator(
        task_id='ingest',
        bash_command='python \
        /home/ollin/Documentos/migration/migration-networks/common/ingest/src/asylum_seekers.py',
        dag = dag)

opr_delimiter = BashOperator(
        task_id='delimiter',
        bash_command='sh \
        /home/ollin/Documentos/migration/migration-networks/common/ingest/src/delimiter.sh ',
        dag = dag)

opr_graph = BashOperator(
        task_id='graph',
        bash_command='zsh \
        /home/ollin/Documentos/migration/migration-networks/common/ingest/src/to_graph.sh ',
        dag = dag)

opr_ingest >> opr_delimiter >> opr_graph
