import os
from datetime import datetime

from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import SnowflakeUserPasswordProfileMapping

# Define your profile config for Snowflake
profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id="snowflake_con",  # Airflow connection ID
        profile_args={
            "account": "ogompbg-jc92948",
            "database": "UBER_DATA",
            "schema": "UBER",
            "warehouse": "COMPUTE_WH",
            "role": "ACCOUNTADMIN"
        },
    ),
)

# Define the dbt project config
project_config = ProjectConfig(
    dbt_project_path="/usr/local/airflow/dags/uberdbt",  # Path to your dbt project
)

# Define the dbt execution config
execution_config = ExecutionConfig(
    dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt",  # Path to dbt executable
)

# Define the dbt DAG (Cosmos 1.x style)
dbt_snowflake_dag = DbtDag(
    dag_id="dbt_snowflake_pipeline",          # ✅ Pass dag_id directly
    schedule="@daily",                # ✅ Pass schedule directly
    start_date=datetime(2023, 9, 10),
    catchup=False,
    project_config=project_config,
    profile_config=profile_config,
    execution_config=execution_config,
    operator_args={"install_deps": True},
)
