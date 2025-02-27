


SELECT
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 la
ON ci.cst_key = la.cid

-- After joining table, check if any duplicates were introduced by the join logic (use the COUNT function, grouping by cst_id).





SELECT * FROM Silver.crm_cust_info

SELECT * FROM Silver.erp_cust_az12

SELECT * FROM Silver.erp_loc_a101
