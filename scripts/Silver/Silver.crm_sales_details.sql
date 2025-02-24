/*

Clean & Load crm_sales_details

Before applying transformations and cleansing tasks, I need to detect the quality issues in the Bronze layer.

*/

-- Quality Check 1: I check column sls_ord_num for unwanted spaces (since there are not unwanted spaces, I'll leave the table as it is).

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM Bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Quality Check 2: Integrity of those columns that I'll use to create relationships to other tables.

INSERT INTO Silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt,
	CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity*ABS(sls_price)
		THEN sls_quantity*ABS(sls_price)
	ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales/NULLIF(sls_quantity, 0)
	ELSE sls_price
	END AS sls_price
FROM Bronze.crm_sales_details
--WHERE sls_prd_key NOT IN (SELECT prd_key FROM Silver.crm_prd_info)
--	AND ALSO
--WHERE sls_cust_id NOT IN (SELECT cst_id FROM Silver.crm_cust_info)

/* Quality Check 3: Invalid Dates
	- Check for negative numbers (negative numbers or zeros can't be cast to a date).
	- Check the length (length should be always 8).
	- Check the boundaries (E.g., to not have dates lowers than 1900, or higher than 2050). */

SELECT
NULLIF(sls_order_dt, 0) sls_order_dt
FROM Bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

/* I'm checking first the sls_order_dt:

	   - There are no negative values, but there are zeros, so I'm turning them to NULLS.
	   - Also, there are a couple of cases where the length of the date is not equal to 8.
	   - I'm updating the SELECT query above to turn these 2 cases into NULLS.
	   - I'm also CASTING the field to VARCHAR first, since I can't CAST INTEGER to DATES directly. 
	   
   I'm applying these same checks to the rest of the dates.
   For the cases where I don't find any quality issue, I could not apply any transformation, but then
   I'll need to set a Quality Check that is gonna be run regularly to identify quality issues in the future.
   Anyway, in this case I'm gonna be applying the same transformations to the fields that I've already applied to the sls_order_dt. */

-- Quality Check 4: The Order Date must always be earlier than the Shipping Date or Due Date.

SELECT *
FROM Bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- All the Order Dates are correct, so no transformation needed here.

/* Quality Check 5: Data consistency between Sales, Quantity and Price.

	>> Sales = Quantity*Price
	>> Values must not be NULL, zero or negative. */

SELECT DISTINCT
sls_sales old_sls_sales,
sls_quantity,
sls_price old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity*ABS(sls_price)
		THEN sls_quantity*ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales/NULLIF(sls_quantity, 0)
	ELSE sls_price
END AS sls_price
FROM Bronze.crm_sales_details
WHERE sls_sales != sls_quantity*sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

/* For the quality issues appearing after applying this last check, I should go first and talk to the experts owning the
   sources of the data, then I could get two possible answers:

		- Solution 1: The owners of the sources will solve the quality issues in the source.
		- Solution 2: The data won't be fixed in the source, so I could leave it as it is, or fix it in the DWH.

   For the second scenario, I'll still need to talk to the owners of the data to use the rules related to the fields.
   Let's say those rules are:

		- If Sales is negative, zero, or NULL, derive it using Quantity and Price.
		- If Price is zero or NULL, calculate it using Sales and Quantity.
		- Ir Prices is negative, convert it to a positive value. */

-- Now, I'll integrate the last check and related transformation into the main SELECT query above.

/* Now that I have clean data, I'm going to compare the clean data to the CREATE query for the Silver table, to confirm
   if the table is still ok or if it needs any tweak. 
   
   As I'll see, the dates are not INT anymore, but DATES. */

IF OBJECT_ID ('Silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE Silver.crm_sales_details;
CREATE TABLE Silver.crm_sales_details (
	sls_ord_num		NVARCHAR(50),
	sls_prd_key		NVARCHAR(50),
	sls_cust_id		INT,
	sls_order_dt	DATE,
	sls_ship_dt		DATE,
	sls_due_dt		DATE,
	sls_sales		INT,
	sls_quantity	INT,
	sls_price		INT,
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);

/* Finally, after inserting the clean data into the Silver table, I'll need to run again the Quality Checks,
   but now applied to the Silver table.
   
   For the check related to the Sales, Quantity and Prices, I'm removing the transformations since I don't
   need them here. */

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM Silver.crm_sales_details
WHERE sls_sales != sls_quantity*sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

SELECT * FROM Silver.crm_sales_details
