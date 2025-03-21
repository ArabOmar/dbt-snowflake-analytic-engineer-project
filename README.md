# Analytic Engineer project with Sniwlake and dbt 

### Introduction

This project leverages Jinja-style SQL templating to optimize data transformations while incorporating software engineering principles into analytics pipelines. By utilizing dbt (Data Build Tool) and Snowflake, it enhances data modeling, automated testing, and orchestration, ensuring a scalable and reliable analytics workflow.

Designed to simulate the role of an Analytics Engineer at Airbnb, the project focuses on essential data transformation processes, from loading raw data into the warehouse to cleaning, structuring, and refining it for analytical use. Data reliability is reinforced through automation, including testing, documentation, and scheduling. This approach demonstrates how modern data engineering tools streamline analytics workflows, improve data governance, and facilitate data-driven decision-making.


### Architecture

![Architecture Diagram](https://github.com/ArabOmar/dbt-snowflake-analytic-engineer-project/blob/main/Images/dbt_project_archi.png)


### Technologies Used

1. **dbt (Data Build Tool)** – A development framework that enables data analysts and engineers to write modular SQL queries, manage transformations, and implement testing, documentation, and version control in a scalable way.

2. **Snowflake** – A fully managed, cloud-based data warehouse that offers high performance, scalability, and secure data storage for analytics and business intelligence workloads.

3. **Dagster** – A modern data orchestration tool that helps manage complex data pipelines with features like dependency management, observability, and error handling to ensure reliable workflows.

4. **Tableau Software** – A leading data visualization and business intelligence platform that allows users to create interactive dashboards and reports, enabling data-driven decision-making with real-time insights.


### Dataset Overview  

The dataset used in this project comes from **Inside Airbnb**, a platform that provides publicly available Airbnb data for various cities worldwide. This specific dataset focuses on **Berlin**, offering insights into Airbnb listings, including details such as property types, locations, prices, availability, host information, and user reviews. It serves as a rich source for analyzing **market trends, pricing strategies, and booking behaviors** within Berlin’s short-term rental market.  

The dataset is periodically updated and curated to support data analysis and research on the impact of Airbnb on local housing markets. More details about this dataset, including its structure and attributes, can be found on **[Inside Airbnb](http://insideairbnb.com/)**.  

### Project Execution Flow

![Data Flow Overview](https://github.com/ArabOmar/dbt-snowflake-analytic-engineer-project/blob/main/Images/Dataflow%20Overview.png)

 #### Data Processing Approach

The project follows a structured data processing approach to ensure **data integrity** and optimize transformations. The data model is organized into multiple layers, each serving a specific function.

- **Staging Layer**: This layer contains temporary, ephemeral tables created using **Common Table Expressions (CTEs)**. These tables are not materialized, enabling lightweight transformations without permanently storing intermediate results.
  
- **Core Layer**: Key models like `dim_listings_cleansed` and `dim_hosts_cleansed` reside in this layer. These models are stored as **views** to facilitate efficient joins while minimizing the need for frequent querying. From these views, the `dim_list_with_hosts` model is derived, which consolidates listings and host data.

- **Fact Layer**: The `fact_reviews` table is an incremental table, updated daily to accommodate new reviews efficiently and allow for scalable data processing.

 #### Data Types and Integration

The project distinguishes between **source data** and **seed data**:

- **Source Data**: These are existing tables and views that are loaded into **Snowflake** through ELT tools like **Fivetran**. This data is the foundation of the transformation pipeline.
  
- **Seed Data**: This consists of manually imported CSV files, such as `seed_full_moon_dates.csv`, which are integrated into Snowflake for analysis. Seed data plays a crucial role in providing supplementary or custom data for specific analyses.

 #### Mart Layer and Historical Data Tracking

The **mart layer** includes tables and views optimized for **Business Intelligence (BI)** tools, providing analysts with structured data for reporting and visualization.

Additionally, **snapshot tables** are created using the **Slowly Changing Dimensions (SCD) Type 2** methodology to track historical changes in raw listings and hosts. These snapshots are executed using the `dbt snapshot` command, which ensures that changes over time are captured without overwriting previous records.


### Core Components Used in dbt

#### Testing in dbt

Ensuring **data quality** is a critical aspect of this project, and dbt's testing capabilities play a significant role in validation. dbt supports two main types of tests:

- **Singular Tests**: These involve custom SQL queries stored in the `tests` directory, where a test passes if it returns zero rows.
  
- **Generic Tests**: dbt provides built-in tests such as `unique`, `not_null`, `accepted_values`, and `relationships`. These tests are defined in YAML files and can be extended or imported from external dbt packages.

For validation purposes, the project applies the four built-in generic tests on the `dim_listings_cleansed` model using the `dbt test` command.

#### Macros in dbt

**Macros** in dbt utilize **Jinja templating** to enable reusable SQL logic. While dbt provides a set of built-in macros, users can create custom macros in the `macros` directory to enhance transformations and tests. These custom macros can be defined with specific signatures and referenced within `schema.yml` for automated testing. Additionally, third-party macros can be imported from dbt packages like **dbt-utils**, which provides functionalities such as **surrogate key generation**. To install these packages, users define the package details in `packages.yml` and execute the `dbt deps` command.

#### Documentation in dbt

Comprehensive **documentation** is crucial for maintaining an organized data pipeline. dbt supports two types of documentation:

1. **YAML-based Metadata Documentation**: This is used for basic model documentation and can be extended to include column descriptions, tests, and relationships.

2. **Standalone Markdown Files**: These are used for more detailed descriptions and narrative-driven explanations of transformations and data models.

Documentation can be generated using the `dbt docs generate` command and accessed via a local documentation server with `dbt docs serve`. This feature improves transparency and usability for analytics teams, providing an accessible reference for the data pipeline.

#### Advanced Features

- **Analysis Folder**: dbt's `analysis` folder allows users to create and compile **SQL queries** for ad-hoc analysis without creating formal models. This is especially useful for exploratory data analysis (EDA) and hypothesis testing.

- **Hooks**: dbt provides hooks to execute SQL commands at specific points in the workflow. There are four types of hooks:
  - `on_un_start`: Before the execution starts.
  - `on_run_end`: After the execution ends.
  - `pre-hook`: Before a model or a task runs, useful for setting up temporary tables or enforcing constraints.
  - `post-hook`: After a model or task runs, useful for logging, auditing, and triggering downstream processes.

By leveraging hooks, dbt automates various administrative tasks, enhancing efficiency and governance.

#### Debugging & Logging

To ensure the reliability of the data pipeline, the project integrates **dbt-expectations**, an open-source data testing framework that extends dbt’s default tests with pre-built logic. This helps detect potential data issues early in the process.

dbt also supports comprehensive **logging**, with logs stored in the `dbt.log` file within the `logs` folder. These logs can be viewed in the terminal by setting `info=True`. Additionally, messages can be temporarily disabled using the Jinja `{#...#}` syntax, providing flexibility in debugging.

#### Variable Management

The project utilizes two types of variables:

- **Jinja Variables**: These are part of the Jinja templating language and are used within dbt models and macros.
  
- **dbt Variables**: These are passed through the command line (e.g., `dbt run --var='example_var:value'`) or defined in the `dbt_project.yml` file. When both types are defined, the command-line variable takes precedence over the configuration file.



