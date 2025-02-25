/*

Clean & Load erp_loc_a101

Before applying transformations and cleansing tasks, I need to detect the quality issues in the Bronze layer.

*/

SELECT * FROM Bronze.crm_cust_info

SELECT * FROM Bronze.erp_loc_a101

-- Quality Check 1: Tweak the cid to match the format used in other tables (crm_cust_info and the transformed erp_cust_az12).

SELECT
cid,
CASE WHEN cid LIKE 'AW-%' THEN CONCAT(SUBSTRING(cid, 1, 2), SUBSTRING(cid, 4, LEN(cid)))
	 ELSE cid
END AS cid
FROM Bronze.erp_loc_a101

-- Quality Check 2: Invalid cntry values

SELECT DISTINCT cntry FROM Bronze.erp_loc_a101

SELECT
CASE WHEN cntry IN ('DE', 'Germany') THEN
	 WHEN cntry IN ('US', 'USA', 'United States') THEN
	 WHEN cntry = 'US' THEN
