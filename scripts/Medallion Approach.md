# Medallion Approach

---

## 1. Prepare everything.

---

## 2. Bronze Layer.

#### <ins>a/ Analyzing: Interview Source System Experts.</ins>

#### <ins>b/ Coding: Data Ingestion.</ins>

  * **Create DDL**: Ask the technical experts from the source system to understand the metadata or directly explore
    the data to identify column names and data types (Data Profiling) to define the structure of the tables.

    Follow the **Naming Convention** that was defined previously.

    Add the conditional T-SQL statement before CREATE TABLE to drop the table in case it already exists.

  * Develop SQL Load Scripts, load the data and apply some checks to confirm it was loaded properly.

    **TRUNCATE TABLE statement should be used before the Load Scripts**, to ensure we're not duplicating data (since in this case
    we're using the Full Load method).

  * Create Stored Procedure.

#### <ins>c/ Validating: Data Completeness & Schema Checks.</ins>

  * **Compare** the data in the Bronze Layer to the data in the Source System, to ensure we're not loosing any data.

  * Confirm the data is in the correct place, by making sure it's under the appropriate schema.

#### <ins>d/ Docs & Version: Data Documenting Versioning in GIT.</ins>

---

## 3. Silver Layer

#### <ins>a/ Analyzing: Explore and Understand the Data.</ins>

  * Understand the data within the tables and how to connect those (create **relationships**).

    **Create the Integration Model.**

#### <ins>b/ Coding: Data Cleansing.</ins>

  * Add Metadata columns.

  * Check Quality of Bronze, then write Data Transformations.

     - crm_cust_info

        a/ Check for Nulls or Duplicates in Primary Key.

           Use the ROW_NUMBER function to pick up only the cst_id occurrence with the MAX cst_create_date

        b/ Check for unwanted spaces (I can apply this check in all the string values within the table).

           Use the TRIM function to transform the affected values.

        c/ Data Standardization and Consistency.

           I review the DISTINCT values of cst_marital_status and cst_gndr, and maybe I could decide that I don't want to use
           abbreviated terms, so I'll have to turn those abbreviations into more clear and meaningful values by using the
           CASE WHEN statement (also, I could turn the NULL values into 'N/A' or 'Unknown').

     - crm_prd_info
   
         a/ Check for Nulls or Duplicates in Primary Key.

         b/ I use the SUBSTRING function to split the values in prd_key, and then I compare the new values to the ones that exist
            in the related table: In this case I see that I have to REPLACE '-' by '_' in the cat_id, then I'll compare values in
            both tables (filter out) to see if there are values that do not exist in one of the tables (that might be not wrong).

  * Insert into Silver.

  * Apply the Quality Checks again, now in the newly created Silver Layer tables, to confirm everything is ok.

#### <ins>c/ Validating: Data Correctness Checks.</ins>

#### <ins>d/ Docs & Version: Data Documenting Versioning in GIT.</ins>
