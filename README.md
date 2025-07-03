🚀 Uber Data Pipeline with Airflow, dbt & Snowflake
This project implements a data pipeline using:

Apache Airflow (for orchestration)

dbt (for transformations)

Snowflake (as the data warehouse)

Astronomer Cosmos (for integrating dbt in Airflow)

It processes Uber trip data to generate business-ready marts for analytics and Power BI dashboards.

📂 Project Structure

.
├── airflow/
│   ├── dags/
│   │   ├── uberdag.py         # Airflow DAG using Cosmos
│   │   └── uberdbt/           # dbt project (models, seeds, etc.)
│   ├── Dockerfile
│   └── requirements.txt       # Airflow & Cosmos dependencies
├── dbt/
│   ├── dbt_project.yml
│   ├── models/
│   └── profiles.yml
├── .env                        # Environment variables for Airflow & Snowflake
├── docker-compose.yml          # Orchestrates Airflow with dbt
└── README.md
🛠 Prerequisites
✅ Install Docker & Docker Compose
✅ Snowflake account (with warehouse & schema created)
✅ Python 3.8+ (for local dbt testing)

⚙️ Setup
1️⃣ Clone the repository
bash
Copy
Edit
git clone https://github.com/<your-username>/uber-data-pipeline.git
cd uber-data-pipeline
2️⃣ Configure Airflow connection for Snowflake
In Airflow UI:

Go to Admin → Connections → New

Add a Snowflake connection:

Field	Value
Conn Id	snowflake_conn
Conn Type	Snowflake
Account	your_account.region (e.g. jc92948.ap-south-1)
Warehouse	COMPUTE_WH
Database	dbt_db
Schema	dbt_schema
Login	Your Snowflake username
Password	Your Snowflake password

3️⃣ Spin up Airflow
bash
Copy
Edit
docker-compose up -d
Access Airflow at http://localhost:8080
(Default user: airflow, password: airflow)

4️⃣ Initialize dbt
Inside the Airflow container:

bash
Copy
Edit
docker exec -it <scheduler-container> bash
cd /usr/local/airflow/dags/uberdbt
dbt deps  # Install dbt dependencies
🚦 Running the Pipeline
✅ Trigger the DAG in Airflow UI: dbt_snowflake_pipeline

This will:

Run dbt transformations (staging → intermediate → marts).

Load marts into Snowflake for analytics.

📊 BI Dashboard
Once data is in Snowflake, you can connect Power BI/Tableau directly to:

Trips mart: Detailed trip-level data

Vendors mart: Aggregated metrics by vendor

Payments mart: Payment type breakdown

🧪 Testing
Run dbt tests:

bash
Copy
Edit
dbt test --profiles-dir profiles
🔑 Key Technologies
Apache Airflow: Workflow orchestration

dbt: Data transformations & models

Snowflake: Cloud data warehouse

Astronomer Cosmos: Native dbt + Airflow integration

🚀 Next Improvements
Incremental dbt models for large datasets

Role-based Airflow connections

Deploy on AWS ECS / GCP Composer
