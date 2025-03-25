# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository.

This is a project proposed by [Baraa Khatib Salkini](https://www.linkedin.com/in/baraa-khatib-salkini/?originalSubdomain=de), where we're building a Data Warehouse from scratch: We're loading data to a SQL Server database, where we're analyzing, cleaning and transforming it so the data can be utilized by final users.

In this case, we're using the Medallion Approach, where we're building 3 layers:
  
  * **Bronze**: Staging, Raw Data.
  * **Silver**: Clean and Transform.
  * **Gold**: Business Ready Objects.

  ## High Level Architecture

<p align="center">
  <img src="https://github.com/user-attachments/assets/84a4889d-d1b6-4013-aec3-8451b32be77f" />
</p>

---

## Tools

For the completion of this project, we've been using the following tools:

  * [Datasets](https://github.com/JoANeS86/sql-data-warehouse-project/tree/main/datasets): Datasets containing source data for this project.
  * [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads): Light version of SSMS.
  * [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16): Integrated environment for managing any SQL infrastructure.
  * [Git Repository](https://github.com/): Code Hosting Platform for collaboration and version control
  * [DrawIO](https://www.drawio.com/): Diagramming Application.
  * [Notion](https://www.notion.so/Data-Warehouse-Project-19102db496af80cc9984cc54b543ae7f): Project Management Tool.

---

## Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specification
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Data Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

- ### BI: Analytics & Reporting (Data Analytics)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

---

## License

This project is licensed under the [MIT LIcense](LICENSE). You are free to use, modify, and share this project with proper attribution.

## About Me
