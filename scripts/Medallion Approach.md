

## 1. Prepare everything.

---

## 2. Bronze Layer.

#### a/ Analyzing: Interview Source System Experts.

#### b/ Coding: Data Ingestion.

  * **Create DDL**: Ask the technical experts from the source system to understand the metadata or directly explore
    the data to identify column names and data types (Data Profiling) to define the structure of the tables.

    Follow the **Naming Convention** that was defined previously.

    Add the conditional T-SQL statement before CREATE TABLE to drop the table in case it already exists.

  * Develop SQL Load Scripts, load the data and apply some checks to confirm it was loaded properly.

    **TRUNCATE TABLE statement should be used before the Load Scripts**, to ensure we're not duplicating data (since in this case
    we're using the Full Load method).

  * Create Stored Procedure.

#### c/ Validating: Data Completeness & Schema Checks.

  * **Compare** the data in the Bronze Layer to the data in the Source System, to ensure we're not loosing any data.

  * Confirm the data is in the correct place, by making sure it's under the appropriate schema.

#### d/ Docs & Version: Data Documenting Versioning in GIT.

---

## 3. Silver Layer
