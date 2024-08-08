#!/bin/bash
set -e

# Ensure Python and Pip are available
PYTHON=$(command -v python)
PIP=$(command -v pip)

# Upgrade pip and install requirements if requirements.txt exists
if [ -f "/opt/airflow/requirements.txt" ]; then
  $PYTHON -m pip install --upgrade pip
  $PIP install --user -r /opt/airflow/requirements.txt
fi

# Initialize Airflow database and create an admin user if not already done
if [ ! -f "/opt/airflow/airflow.db" ]; then
  airflow db init && \
  airflow users create \
    --username admin \
    --firstname admin \
    --lastname admin \
    --role Admin \
    --email admin@example.com \
    --password admin
fi

# Upgrade the Airflow database
airflow db upgrade

# Start the Airflow webserver
exec airflow webserver
