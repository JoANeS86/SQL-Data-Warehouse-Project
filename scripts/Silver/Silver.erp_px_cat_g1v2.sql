/*

Clean & Load erp_px_cat_g1v2

Before applying transformations and cleansing tasks, I need to detect the quality issues in the Bronze layer.

*/

INSERT INTO Silver.erp_px_cat_g1v2 (
	id,
	cat,
	subcat,
	maintenance
)

SELECT
	id,
	cat,
	subcat,
	maintenance
FROM Bronze.erp_px_cat_g1v2

-- Check for unwanted spaces

SELECT
cat,
subcat,
maintenance
FROM Bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Standardization & Consistency

SELECT DISTINCT
cat
FROM Bronze.erp_px_cat_g1v2

SELECT DISTINCT
subcat
FROM Bronze.erp_px_cat_g1v2

SELECT DISTINCT
maintenance
FROM Bronze.erp_px_cat_g1v2

-- Data is ok, so I don't need to clean up anything.

SELECT * FROM Silver.erp_px_cat_g1v2
