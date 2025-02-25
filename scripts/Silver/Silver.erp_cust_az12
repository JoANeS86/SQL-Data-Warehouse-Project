/*

Clean & Load erp_cust_az12

Before applying transformations and cleansing tasks, I need to detect the quality issues in the Bronze layer.

*/

/* Quality Check 1: By taking a look to the model, I can see that I can connect the erp_cust_az12 table to the crm_cust_info
   through fields cid and cst_key. However, I see prefix 'NAS' is used in the values under field cid, which makes the values
   different from the ones under the cst_key field (and there's not an explanation for that prefix or what it means).
   
   Looks like old data had that 'NAS' prefix and now new data doesn't have it, so I need to clean up those ids
   in order to be able to connect the tables. */

INSERT INTO Silver.erp_cust_az12 (
	cid,
	bdate,
	gen
)

SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	 ELSE cid
END cid,
CASE WHEN bdate > GETDATE() THEN NULL
	 ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 ELSE 'N/A'
END AS gen
FROM Bronze.erp_cust_az12

/* I could add the piece of code below to compare the transformed cid field to the cst_key:

WHERE
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
	END
NOT IN (SELECT DISTINCT cst_key FROM Bronze.crm_cust_info) */

/* Quality Check 2: Identify Out-Of-Range dates.

   There are some old dates that are strange, but could be ok, and then there are some bdates that are in the future,
   which are definitely wrong (I should at least turn to NULL these last in the main query above). */

SELECT DISTINCT
bdate
FROM Bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Quality Check 3: Invalid gender values.

SELECT DISTINCT
gen
FROM Bronze.erp_cust_az12

-- Transformation to correct values:

SELECT DISTINCT
gen,
CASE WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 ELSE 'N/A'
END AS gen
FROM Bronze.erp_cust_az12

-- Finally, as usual, I must apply the Quality Checks to the new Silver table.
