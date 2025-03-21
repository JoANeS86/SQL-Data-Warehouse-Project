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

     **- crm_cust_info**

        a/ Check for Nulls or Duplicates in Primary Key.

           Use the ROW_NUMBER function to pick up only the cst_id occurrence with the MAX cst_create_date

        b/ Check for unwanted spaces (I can apply this check in all the string values within the table).

           Use the TRIM function to transform the affected values.

        c/ Data Standardization and Consistency.

           I review the DISTINCT values of cst_marital_status and cst_gndr, and maybe I could decide that I don't want to use
           abbreviated terms, so I'll have to turn those abbreviations into more clear and meaningful values by using the
           CASE WHEN statement (also, I could turn the NULL values into 'N/A' or 'Unknown').

     **- crm_prd_info**
   
         a/ Check for Nulls or Duplicates in Primary Key.

         b/ I use the SUBSTRING function to split the values in prd_key, and then I compare the new values to the ones that exist
            in the related table: In this case I see that I have to REPLACE '-' by '_' in the cat_id, then I'll compare values in
            both tables (filter out) to see if there are values that do not exist in one of the tables (that will need to be reviewed
            to decide if it's wrong or not).

            I do the same with the second part of the split.

         c/ Check for unwanted spaces (I can apply this check in all the string values within the table).

         d/ Search for negative numbers or NULLS in the prd_cost (for the NULLS, I can use the COALESCE or the ISNULL functions to replace
            the NULLS by zeros).

         e/ Data Standardization and Consistency. Same process as the one explained for the crm_cust_info table.

         f/ Comparison of dates (end Date must not be earlier than the start date).

            Since many results are retrieved by this check, it's advisable to narrow the results down, i.e., to pick up a specific
            sample and review it.

            One potential solution here is to switch the dates, but in this case this is causing overlapping date, and also some cases
            where we have a NULL as a prd_start_dt (each record must have a start date), so it looks like a more solid solution to derive
            the End Date from the Start Date (the End Date of the current record will come from the Start Date of the next record, i.e.,
            End Date = Start Date of the next record -1).

            In order to apply the mentioned solution, I'll use the LEAD function.

            Finally, I can CAST the Dates to remove the time part, since in this case it's not containing any information, but if I do
            that, then I'll need to update the metadata of this Silver table, so these Dates will go from DATETIME to DATE data type.

  * Insert into Silver.

  * Apply the Quality Checks again, now in the newly created Silver Layer tables, to confirm everything is ok.

#### <ins>c/ Validating: Data Correctness Checks.</ins>

#### <ins>d/ Docs & Version: Data Documenting Versioning in GIT.</ins>
