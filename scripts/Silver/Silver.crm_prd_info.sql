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
prd_line,
prd_start_dt,
prd_end_dt
FROM Bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN
(SELECT DISTINCT ID FROM Bronze.erp_px_cat_g1v2)

SELECT * FROM Bronze.crm_prd_info

-- Quality Check 3: Check for unwanted spaces in string values.

SELECT prd_nm
FROM Bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Quality Check 4: Check for NULLS or Negative Numbers (Negative Numbers could make or not sense depending on the case).

SELECT prd_cost
FROM Bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0
