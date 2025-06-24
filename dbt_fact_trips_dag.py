import os
from datetime import datetime
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import SnowflakeUserPasswordProfileMapping

# 1. Profile config: maps to Airflow Snowflake connection
profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id="snowflake_default",  # Ensure this exists in Airflow UI
        profile_args={
            "database": "UBER_DATA",
            "schema": "UBER",
            "warehouse": "COMPUTE_WH",
            "role": "ACCOUNTADMIN"
        },
    ),
)

# 2. Execution config: points to dbt path and selects only fact_trips
execution_config = ExecutionConfig(
    dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt",  # adjust if needed
    # select=["fact_trips"]
)

# 3. Define the dbt DAG
dbt_snowflake_dag = DbtDag(
    dag_id="dbt_fact_trips_dag",
    project_config=ProjectConfig("/usr/local/airflow/dags/uber_dbt_project"),  # path to your dbt project
    profile_config=profile_config,
    execution_config=execution_config,
    operator_args={"install_deps": True},  # installs packages on run
    schedule_interval="@daily",
    start_date=datetime(2023, 9, 10),
    catchup=False,
)
