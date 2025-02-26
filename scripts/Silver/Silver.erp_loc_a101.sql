/*

Clean & Load erp_loc_a101

Before applying transformations and cleansing tasks, I need to detect the quality issues in the Bronze layer.

*/

SELECT * FROM Bronze.crm_cust_info

SELECT * FROM Bronze.erp_loc_a101

-- Quality Check 1: Tweak the cid to match the format used in other tables (crm_cust_info and the transformed erp_cust_az12).

INSERT INTO Silver.erp_loc_a101 (
	cid,
	cntry
)

SELECT
REPLACE(cid, '-', '') cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
	 ELSE TRIM(cntry)
END AS cntry
FROM Bronze.erp_loc_a101
-- WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM Silver.crm_cust_info)

/* Quality Check 2: Invalid cntry values
   After integrating the transformation in the main query above, I can add it to the Quality Check too, to compare the old
   erroneous values to the new ones and confirm at a glance that I'm not missing anything. */

SELECT DISTINCT cntry
FROM Bronze.erp_loc_a101
ORDER BY cntry

SELECT
	DISTINCT cntry old_cntry,
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
	 ELSE TRIM(cntry)
END AS cntry
FROM Bronze.erp_loc_a101
ORDER BY cntry

-- As always, final step is to apply the Quality Checks to the Silver table.

SELECT * FROM Silver.erp_loc_a101
