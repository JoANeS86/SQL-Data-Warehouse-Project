/*

Clean & Load crm_prd_info

Before applying transformations and cleansing tasks, I need to detect the quality issues.

*/

-- Quality Check 1: Check for Nulls or Duplicates in Primary Key (a PK must be unique and not null).

SELECT
	prd_id,
	COUNT(*)
FROM Bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

/* Quality Check 2:

	a/ Extracting a specific part of the prd_key (the Category) that we'll use to join this table to the erp_px_cat_g1v2.

	b/ In the erp table, the Category (and Subcategory) are split with an underscore, meanwhile, in the crm table a hyphen
	is used instead. I'm using the REPLACE function to manage that.
	
	c/ I can also compare the values from both tables, to identify if there are cases where existing categories in the crm
	table are no part of the list coming from the erp table.
	
	d/ For the prd_key, if I compare the values here to the ones in table sales_details, I'll see some cases where keys aren't
	there, but that is just because those products where not ordered, so no quality issue there. */

SELECT
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) prd_key, -- Here I'm using LEN since the number of characters that I want to get are not always the same.
prd_nm,
ISNULL(prd_cost, 0) prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	 ELSE 'N/A'
END AS prd_line,
CAST(prd_start_dt AS DATE) prd_start_dt,
CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) prd_end_dt
FROM Bronze.crm_prd_info
-- WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN
-- (SELECT DISTINCT ID FROM Bronze.erp_px_cat_g1v2)

SELECT * FROM Bronze.crm_prd_info

-- Quality Check 3: Check for unwanted spaces in string values.

SELECT prd_nm
FROM Bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Quality Check 4: Check for NULLS or Negative Numbers (Negative Numbers could make or not sense depending on the case).

SELECT prd_cost
FROM Bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0

/* Quality Check 5: Data Standardization & Consistency (column 'prd_line').
   Identification of all the unique values to be used in the above CASE WHEN. */

SELECT DISTINCT prd_line
FROM Bronze.crm_prd_info

-- Quality Check 6: Check for Invalid Date Orders

SELECT *
FROM Bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt

/* Once I've identified those cases where the start_dt is higher than the end_dt, I'm picking up a couple of cases and
move them to Excel to figure out a potential solution:

	#1 Solution: I swap the dates, moving the end_dt to the start_dt and the other way around.
	   However, this solution doesn't look good enough, first because there's overlapping between the ranges of dates
	   for same products (meaning we have both, prd_cost 12 and 14 for the same product in 2010, for example).
	   Another problem is that we have a NULL as start_dt, but each record must have a Start Date.

	#2 Solution: Derive the End Date from the Start Date (we ignore current End Date and rebuild the field by using the
	   info we're retrieving from the Start Date), so the End Date of the current record comes from the Start Date of
	   the next record (End Date = Start Date of the next record -1).
	   For the last record, since there's no next, I'm just using NULL for the End Date.
	   I'm using the LEAD function to apply this solution, as added in the code above. */

/* Additional tweak: I'm removing the time from the dates, since it's always 0, so it makes no sense to keep it.
   I'm using the CAST function for it. */

-- Finally, we have cleaned Product information.

/* Now, I'm coming back to the Silver ddl for the crm_prd_info table, where I'll see that after considering the transformation
   that I've completed to clean the data, I'll need an additional field (cat_id) and update the data type of the dates (from
   DATETIME to DATE). */

   IF OBJECT_ID ('Silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE Silver.crm_prd_info;
   CREATE TABLE Silver.crm_prd_info (
	prd_id				INT,
	cat_id				NVARCHAR(50),
	prd_key				NVARCHAR(50),
	prd_nm				NVARCHAR(50),
	prd_cost			INT,
	prd_line			NVARCHAR(50),
	prd_start_dt		DATE,
	prd_end_dt			DATE,
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
)

-- Now I insert the cleaned data into the Silver table for products.

INSERT INTO Silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) prd_key, -- Here I'm using LEN since the number of characters that I want to get are not always the same.
prd_nm,
ISNULL(prd_cost, 0) prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	 ELSE 'N/A'
END AS prd_line,
CAST(prd_start_dt AS DATE) prd_start_dt,
CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) prd_end_dt
FROM Bronze.crm_prd_info

/* Now I have to check the quality of the Silver table, by using the quality checks defined above,
   but  after replacing 'Bronze' by 'Silver'. */

   SELECT * FROM Silver.crm_prd_info
