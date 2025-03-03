CREATE VIEW Gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL

/* In the crm table I have historical data, but now I've decided that I only need the current data, that's why I'm filtering out
   old data (I'll do that through the prd_end_dt, so if that field is NULL, it means the info of the product is current).
   
   Once I've applied that filter, I can remove the prd_end_dt from the final result, since it's always gonna be NULL.

   - After joining table, check if any duplicates were introduced by the join logic (use the COUNT(*), grouping by prd_key).

   - In this case, as opposed to the gender in the Customers Dimension, I don't have anything to be integrated.

   - Next, I'm gonna sort the columns into logical groups to improve readability

   - Next, I'm giving friendly names to fields by following the General Principles that I defined at the beginning of the
     project.
	 
   - As in the case of the Customers, this case is also a Dimension.
   
   - And as in the case of the Customers, again, I'm creating a Surrogate Key through ROW_NUMBER.
   
   - Finally, I'm creating the View. */

SELECT * FROM Gold.dim_products
