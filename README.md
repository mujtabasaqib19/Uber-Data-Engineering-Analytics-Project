🚀 Uber Data Pipeline: Airflow + dbt + Snowflake
This project implements a modern data pipeline for processing Uber trip data. It uses Apache Airflow for orchestration, dbt for data transformations, and Snowflake as the cloud data warehouse. The pipeline creates analytics-ready marts that can be used for Power BI or Tableau dashboards.

📂 Project Structure
text
Copy
Edit
.
├── airflow/
│   ├── dags/
│   │   ├── uberdag.py          # Airflow DAG (Cosmos integrated)
│   │   └── uberdbt/            # dbt project (models, seeds, etc.)
│   ├── Dockerfile              # Airflow container setup
│   └── requirements.txt        # Airflow & Cosmos dependencies
├── dbt/
│   ├── dbt_project.yml         # dbt project config
│   ├── models/                 # dbt models: staging, intermediate, marts
│   └── profiles.yml            # dbt profiles
├── docker-compose.yml          # Orchestrates Airflow + dbt
├── .env                        # Environment variables for Snowflake
└── README.md                   # Project documentation
🛠️ Prerequisites
✅ Docker & Docker Compose installed
✅ Snowflake account with database and schema configured
✅ Python 3.8+ for local dbt testing

⚙️ Setup
1️⃣ Clone the Repository
bash
Copy
Edit
git clone https://github.com/<your-username>/uber-data-pipeline.git
cd uber-data-pipeline
2️⃣ Configure Airflow Snowflake Connection
In Airflow UI:

Go to Admin → Connections → New

Add a Snowflake connection:

Field	Value
Conn Id	snowflake_conn
Conn Type	Snowflake
Account	jc92948.ap-south-1 (your account locator)
Warehouse	COMPUTE_WH
Database	dbt_db
Schema	dbt_schema
Login	Your Snowflake username
Password	Your Snowflake password

3️⃣ Start Airflow
bash
Copy
Edit
docker-compose up -d
Access Airflow at http://localhost:8080
(Default credentials: airflow / airflow)

4️⃣ Install dbt Dependencies
Inside the Airflow container:

bash
Copy
Edit
docker exec -it <scheduler-container> bash
cd /usr/local/airflow/dags/uberdbt
dbt deps
🚦 Running the Pipeline
Trigger the DAG in Airflow UI:
✅ dbt_snowflake_pipeline

This will:

Run dbt models in Snowflake (staging → intermediate → marts).

Generate analytics-ready marts for BI dashboards.

📊 Analytics Marts
Mart	Description
trips	Trip-level data with derived features & aggregates
vendors	Vendor-level summaries (total trips, revenue, etc.)
payments	Payment method breakdowns (tips, fares, surcharges)

These marts can be consumed directly in Power BI, Tableau, or Looker.

🧪 Testing
Run dbt tests inside the container:

bash
Copy
Edit
dbt test --profiles-dir profiles
🛠 Technologies Used
Apache Airflow – Orchestration

dbt – Transformations and data modeling

Snowflake – Cloud data warehouse

Astronomer Cosmos – Airflow + dbt integration

