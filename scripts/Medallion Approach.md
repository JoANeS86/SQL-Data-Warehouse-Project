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

     **- crm_sales_details**

         a/ Check for unwanted spaces (I can apply this check in all the string values within the table).

         b/ Next, I compare fields sls_cust_id and sls_prd_key to the related fields in the previous tables, to ensure that I don't have
            values here that aren't in the customer and product tables.

         c/ Values within the date fields are as INTEGER: I need to review these before CASTING them to DATE, to confirm there are no negative
            values or zeros (since those can't be CAST to DATE).

            In this case, some zeros were retrieved, so I'll convert those into NULLS by using the NULLIF function.

            Also, I've seen the meaning of the values (first year, then month and finally day), and I have to confirm now that every value's
            length in that field is 8 (if not 8, then that is poor quality data, and I'll turn those cases into NULLS too).

            Next, check for outliers by validating the boundaries of the date range.

            Finally, I'm CASTING the values: First, from INTEGER to VARCHAR (because I can't direcly CAST INT to DATE), and then VARCHAR to
            DATE.

            Order Date must always be earlier than the Shipping Date or Due Date.

         d/ Sales = Quantity * Price (and in this case, Negative, Zeros and Nulls are Not Allowed).

            For cases that do not comply with that Rule, firstly I reach people from Business or the Source Systems to discuss about it, then,
            it usually ends up in 2 potential solutions: 1, data issues are fixed directly in the source, or 2, there's not enough capacity or
            budget to fix the data issues in the source, so I have to decide whether I leave the data as it is, or if improve the quality of the
            data (and in that case, ask for the experts to support you on the resolution of those issues, since it depends on their rules).

         e/ DDL must be reviewed and updated when needed, to ensure is matching the data after the transformations (e.g., the dates are not INT
            anymore, but DATES).

     **- erp_cust_az12**

         a/ In order to be able to connect this table to others through field 'cid', I'm removing prefix 'NAS' from the values that contain it.

            Regarding field 'bdate', first I confirm the data type, that must be DATE, and then I review if there are values out of range.

            And for 'gen, I review the DISTINCT values to see if any transformation is needed there.

     **- erp_loc_a101**

         a/ In this table, I need to clean the values in 'cid' (to remove the hyphen), and regarding 'cntry', I'm cleaning those values as usual.

     **- erp_px_cat_g1v2**

         a/ First columns is ok, then I check for unwanted spaces and for the data standardization and consistency: Everything is ok this time,
            so no need for any transformation.

  * Insert into Silver.

  * Apply the Quality Checks again, now in the newly created Silver Layer tables, to confirm everything is ok.

#### <ins>c/ Validating: Data Correctness Checks.</ins>

#### <ins>d/ Docs & Version: Data Documenting Versioning in GIT.</ins>
