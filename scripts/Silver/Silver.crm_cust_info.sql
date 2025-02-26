/*

Clean & Load crm_cust_info

Before applying transformations and cleansing tasks, I need to detect the quality issues in the Bronze layer.

*/

-- Quality Check 1: Check for Nulls or Duplicates in Primary Key (a PK must be unique and not null).

SELECT
	cst_id,
	COUNT(*)
FROM Bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1

/* The above query is identifying the duplicates, but in the case of the NULL values, if there was only
one NULL, the above query wouldn't have identified it, so a small update must be made to the query. */

SELECT
	cst_id,
	COUNT(*)
FROM Bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Data Transformation and Data Cleansing for Quality Check 1.

/* If I review one of the quality issues (E.g., cst_id = 29466), I can see there are different create_dates related
to each occurrence, so I'd be interested maintaining the newest one, and then discard the rest.

To do that, I'd need to Rank these values based on the create_date, and then only pick the highest ones. */

SELECT *
FROM Bronze.crm_cust_info
WHERE cst_id = 29466

SELECT * FROM (
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM Bronze.crm_cust_info
) a WHERE flag_last = 1

-- Quality Check 2: Check for unwanted spaces in string values.
-- I could apply this check to any of the string values within the table: firstname, lastname, gender...

SELECT cst_firstname
FROM Bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Transformation and Data Cleansing for Quality Check 2.

SELECT * FROM (
	SELECT
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM Bronze.crm_cust_info
) a WHERE flag_last = 1

-- Quality Check 3: Check the consistency of values in low cardinality columns.

SELECT DISTINCT cst_gndr
FROM Bronze.crm_cust_info

/* We could work with the values obtained in the above query, but we might decide we'd like to
have a rule to use friendly full names rather than abbreviations.

I'm using the UPPER function in the below query to ensure the mapping is covering cases where the
gender is maybe added as lower case (just in case).

Finally, after checking that no more transformations are needed (I'm ok with the create_date field as it is),
I'm adding the INSER INTO statement to populate the Silver.crm_cust_info table with clean data. */

PRINT '>> Truncating Table: Silver.crm_cust_info';
TRUNCATE TABLE Silver.crm_cust_info;
PRINT '>> Inserting Data Into: Silver.crm_cust_info';
INSERT INTO Silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 ELSE 'N/A'
END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 ELSE 'N/A'
END cst_gndr,
cst_create_date
FROM (
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM Bronze.crm_cust_info
	WHERE cst_id IS NOT NULL) A WHERE flag_last = 1

-- Finally, I'll re-run the quality check queries from the Bronze layer to verify the quality of data in the Silver layer.

-- Check 1

SELECT
	cst_id,
	COUNT(*)
FROM Silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check 2 (could be applied to other fields).

SELECT cst_firstname
FROM Silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Check 3

SELECT DISTINCT cst_gndr
FROM Silver.crm_cust_info

-- Select all the info from the table.

SELECT * FROM Silver.crm_cust_info
