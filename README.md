# 🇧🇷 Olist: Brazilian E-Commerce Analytics Pipeline🎯
## 🎯Project Goal
 The objective of this project is to analyze the logistics performance and customer satisfaction of the Brazilian e-commerce giant, [Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data). By transforming raw transactional data into a curated Star Schema, we enable deep-dive insights into delivery efficiency, seller performance, and geographic trends.
## 🏗 Data Architecture & Tech Stack
 This project follows the Medallion Architecture principles, utilizing a modular flow within dbt Cloud and Snowflake.
 
### The Transformation Flow:
1. **Staging** (stg_): Atomic cleaning of raw data. This includes renaming columns to snake_case, casting data types (Timestamps), and utilizing custom macros for **Identity Resolution** and **City Name Standardizatio**n.

2. **Intermediate** (int_): The logic layer. Here, we join across staging models, apply **English translations** to product categories, and handle **Slowly Changing Dimensions (SCD Type 2)** for user history.

3. **Marts** (fct_ & dim_): The consumption layer. Structured as a **Star Schema** designed for BI tools. This is where we define the "Source of Truth" for business entities.

### Tech Stack:
Data Warehouse: Snowflake

**Transformation Tool:** dbt (dbt Cloud)

**dbt Packages:** 
* dbt_utils: Used for surrogate key generation and advanced testing.

* codegen: Used to automate the creation of staging base models and YAML files.

## 📈 Key Business Metrics
### The Perfect Order Rate (POR)
The primary KPI for operational excellence. A "Perfect Order" is defined as an order that meets three strict criteria:
1. **Status:** Successfully delivered.
2. **Logistics:** Delivered **on or before** the estimated delivery date (is_late_delivery = 0).
3. **Satisfaction:** Received a **5-star rating** from the customer.
4. **Calculation:**
$$\text{Perfect Order Rate} = \left( \frac{\text{Total Perfect Orders}}{\text{Total Delivered Orders}} \right) \times 100$$

## 🛠 Features & Engineering Highlights
* **Macro-Driven Cleaning:** Developed a custom macro to handle complex Brazilian character normalization and string cleaning across multiple sources.

* **Identity Resolution:** Implemented a deduplication strategy to separate transactional "Customers" from unique "Users."

* **Historical Tracking:** Configured dbt Snapshots to track user location changes over time, backdated to 2016 for historical integrity.

## 📚 Resources & Data
1. **Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data)

2. **dbt Documentation:** [Learn more about dbt](https://docs.getdbt.com/docs/introduction)

3. **Community:** Join the [dbt Slack](https://community.getdbt.com/) to learn from other analytics engineers.

### How to Run This Project
1. Clone the repository.

2. Run the initial script to create the database and schemas. Use the scripts from the folder: scripts.

3. Set up your profiles.yml or dbt Cloud credentials for Snowflake.

4. Run the initial snapshot: dbt snapshot.

5. Build the entire warehouse: dbt build.

